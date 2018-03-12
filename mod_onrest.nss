#include "matasumon"
#include "nw_i0_tool"
#include "vendas_inc"
#include "RS_inc"
#include "SPC_inc"
#include "Mod_inc"
#include "experience_inc"
#include "domains_inc"
#include "reglasdelacasa"
#include "Time_inc"
#include "Speed_inc"
#include "Skills_Sinergy"
#include "Horses_inc"
#include "ClericCtrl_inc"
#include "Mercenario_inc"


void RestMeUp( int initialDamage ) {
    object subject = OBJECT_SELF;
    int currentDamage = GetMaxHitPoints( subject ) - GetCurrentHitPoints( subject );

    // si es lastimado durante el descanzo, no logra recuperar nada.
    if( currentDamage > initialDamage )
        return;

    FloatingTextStringOnCreature("*Descansaste bien*", subject, FALSE);
    Time_registerRestTime( subject );

    // calcular daño a hacer para que la vida de 'subject' quede como debe
    int constitution = GetAbilityScore( subject, ABILITY_CONSTITUTION, TRUE );
    int damage = currentDamage - ( GetHitDice(subject)*constitution*d4() )/10;

    // Instantly gives this creature the benefits of a rest (restored hitpoints, spells, feats, etc..)
    ForceRest(subject);

    // ajustar la vida de 'subject'
    if( damage > 0 )
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(damage), subject);

    // resetear contador de vendas aplicadas desde ultimo descanzo
    Vendas_onRest();

    // Aliviar sobredosis  ¿se debe aplicar a todos solo a los PJs? ¿no hay que hacer que el mínimo sea cero?
    SetLocalInt(subject, "Sobredosis", GetLocalInt(subject, "Sobredosis")- GetAbilityModifier(ABILITY_CONSTITUTION, subject) - d4(1) );

    if( GetIsPC( subject ) && !GetIsDM( subject ) && !GetIsDMPossessed( subject ) ) {

        RS_onPcSuccessfullyRest( subject );

        SisPremioCombate_onPcSuccessfullyRest( subject );

        Mercenario_onPcSuccessfullyRest( subject );

        if(GetCampaignInt("PVP", "Carcel", subject) > 0)
            SetCampaignInt("PVP", "Carcel", GetCampaignInt("PVP", "Carcel", subject)-1, subject);
        if(GetCampaignInt("PVP", "Carcel", subject) < 10)
            SetCampaignInt("PVP", "Assasin", 0, subject);

        ExecuteScript("prc_rest", subject);  // ¿se debe aplicar solo a los PJs? Rta por dragoncin: no se

        SetLocalInt( subject, "isExportPending", TRUE ); // Hace que se exporte el PJ en el proximo heartbeat.

        // Control de clerigos
        ClericControl_onRest( subject ); // Si, esto es solo para PJs

        //RdlC_penaPorDormirConArmadura(subject);
    }
    //Speed_applyModifiedSpeed( subject );  // ¿se debe aplicar solo a los PJs? Rta por dragoncin: no es siquiera necesario dado que se eligio no modificar velocidades por raza o armadura

    RetributionDomain_onRest(subject); // ¿se debe aplicar solo a los PJs? Rta por dragoncin: no

    Skills_Sinergy_applyGeneralSinergies( subject ); // ¿se debe aplicar solo a los PJs? Rta por dragoncin: no

    Skills_ajustarDisciplina( subject); // ¿se debe aplicar a todos o solo a los PJs? Rta por dragoncin: a todos
}



///////////////////////////////// RESTING STUFF - begin ////////////////////////

const float doRestingStuff_REST_TIME_PARTITION = 5.0;

// Quita de 'creature' todos los effectos positivos creados por 'effectCreator'.
void doRestingStuff_removePositiveEffects( object creature, object effectCreator );
void doRestingStuff_removePositiveEffects( object creature, object effectCreator ) {
    effect effectIterator = GetFirstEffect(creature);
    while( GetIsEffectValid(effectIterator) ) {
        if( GetEffectCreator( effectIterator ) == effectCreator ) {
            switch( GetEffectType( effectIterator ) ) {
                case EFFECT_TYPE_ABILITY_INCREASE:
                case EFFECT_TYPE_AC_INCREASE:
                case EFFECT_TYPE_ATTACK_INCREASE:
                case EFFECT_TYPE_CONCEALMENT:
                case EFFECT_TYPE_DAMAGE_REDUCTION:
                case EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE:
                case EFFECT_TYPE_ELEMENTALSHIELD:
                case EFFECT_TYPE_ETHEREAL:
                case EFFECT_TYPE_HASTE:
                case EFFECT_TYPE_IMMUNITY:
                case EFFECT_TYPE_IMPROVEDINVISIBILITY:
                case EFFECT_TYPE_INVISIBILITY:
                case EFFECT_TYPE_MOVEMENT_SPEED_INCREASE:
                case EFFECT_TYPE_REGENERATE:
                case EFFECT_TYPE_SANCTUARY:
                case EFFECT_TYPE_SAVING_THROW_INCREASE:
                case EFFECT_TYPE_SEEINVISIBLE:
                case EFFECT_TYPE_SKILL_INCREASE:
                case EFFECT_TYPE_SPELL_IMMUNITY:
                case EFFECT_TYPE_SPELL_RESISTANCE_INCREASE:
                case EFFECT_TYPE_SPELLLEVELABSORPTION:
                //case EFFECT_TYPE_TEMPORARY_HITPOINTS:
                case EFFECT_TYPE_TRUESEEING:
                case EFFECT_TYPE_TURN_RESISTANCE_INCREASE:
                case EFFECT_TYPE_ULTRAVISION:
                    RemoveEffect( creature, effectIterator );
            }
        }
        effectIterator = GetNextEffect(creature);
    }
}

int doRestingStuff_isAnyCreatureRestingInArea( object area ) {
    object objectIterator = GetFirstObjectInArea( area );
    while( objectIterator != OBJECT_INVALID ) {
        if(
            GetObjectType( objectIterator ) == OBJECT_TYPE_CREATURE
            && GetLocalInt( objectIterator, Mod_isResting_VN )
        )
            return TRUE;

        objectIterator = GetNextObjectInArea( area );
    }
    return FALSE;
}

void doRestingStuff_enterDream() {
    // matar summons de subject
    object partyMemberIterator = GetFirstFactionMember( OBJECT_SELF, FALSE );
    while( partyMemberIterator != OBJECT_INVALID ) {
        matasumon( partyMemberIterator, OBJECT_SELF );
        doRestingStuff_removePositiveEffects( partyMemberIterator, OBJECT_SELF );
        partyMemberIterator = GetNextFactionMember( OBJECT_SELF, FALSE );
    }
    object area = GetArea( OBJECT_SELF );
    int chance = GetLocalInt( area, RS_estado_VN ) == RS_Estado_HOSTIL ? 2 : 10; // 50% de que se genere el encuentro por descanso si el área esta hostil, 10% si esta en alerta.
    if( Random(chance) == 0 && GetLocalInt( area, RS_crArea_PN ) > 0 && !doRestingStuff_isAnyCreatureRestingInArea( area ) )
        RS_generarEncuentro( area, 0.5 );
    SetLocalInt( OBJECT_SELF, Mod_isResting_VN, TRUE );
}

void doRestingStuff_monitorCheck( int sequenceNumber, effect continuousRestEffect, int initialDamage ) {
    int actualSequenceNumber = GetLocalInt( OBJECT_SELF, "sequenceNumber" );
    if( actualSequenceNumber == sequenceNumber || GetMaxHitPoints(OBJECT_SELF) - GetCurrentHitPoints(OBJECT_SELF) > initialDamage ) {
        DeleteLocalInt( OBJECT_SELF, Mod_isResting_VN );
        RemoveEffect( OBJECT_SELF, continuousRestEffect );
        //ClearAllActions(); // cancela las acciones encoladas en doRestingStuff_main()
        if( GetIsPC(OBJECT_SELF) && sequenceNumber > 0 && !GetHasFeat( FEAT_IMMUNITY_TO_SLEEP, OBJECT_SELF ) )
            FadeFromBlack( OBJECT_SELF );
    }
}

void doRestingStuff_monitorSetUp( int sequenceNumber, effect continuousRestEffect, int initialDamage ) {
    SetLocalInt( OBJECT_SELF, "sequenceNumber", sequenceNumber );
    DelayCommand( doRestingStuff_REST_TIME_PARTITION + 3.0, doRestingStuff_monitorCheck( sequenceNumber, continuousRestEffect, initialDamage ) );
}

void doRestingStuff_main() {

    int racialType = GetRacialType( OBJECT_SELF );
    if(
        racialType != RACIAL_TYPE_CONSTRUCT && // Constructs, Oozes, and Undead don't rest.
        racialType != RACIAL_TYPE_UNDEAD &&
        racialType != RACIAL_TYPE_OOZE
    ) {
        FloatingTextStringOnCreature( "*Comienzas a descansar*", OBJECT_SELF, FALSE );
        int initialDamage = GetMaxHitPoints(OBJECT_SELF) - GetCurrentHitPoints( OBJECT_SELF );
        int hasImmunityToSleep = GetHasFeat( FEAT_IMMUNITY_TO_SLEEP, OBJECT_SELF );

        effect continuousRestEffect;
        effect partitionedRestEffect;
        int partitionedRestAnimation;
        if( hasImmunityToSleep ) {
            continuousRestEffect = EffectACDecrease(20);
            partitionedRestEffect = EffectVisualEffect( VFX_IMP_WILL_SAVING_THROW_USE );
            partitionedRestAnimation = ANIMATION_LOOPING_SIT_CROSS;
        }
        else {
            continuousRestEffect = EffectLinkEffects( EffectBlindness(), EffectACDecrease(20) );
            partitionedRestEffect = EffectVisualEffect(VFX_IMP_SLEEP);
            partitionedRestAnimation = ANIMATION_LOOPING_DEAD_BACK;
        }

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, continuousRestEffect, OBJECT_SELF );

        doRestingStuff_monitorSetUp( -1, continuousRestEffect, initialDamage );
        ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, doRestingStuff_REST_TIME_PARTITION );

        ActionDoCommand( doRestingStuff_enterDream() );
        if( GetIsPC(OBJECT_SELF) && !hasImmunityToSleep )
            ActionDoCommand( FadeToBlack( OBJECT_SELF ) );

        int restTime = 4 + GetLocalInt( GetArea(OBJECT_SELF), RS_crArea_PN )/2;
        int counter;
        for( counter = 1; counter <= restTime; ++counter ) {
            ActionDoCommand( doRestingStuff_monitorSetUp( counter, continuousRestEffect, initialDamage ) );
            ActionDoCommand( ApplyEffectToObject( DURATION_TYPE_TEMPORARY, partitionedRestEffect, OBJECT_SELF ) );
            ActionPlayAnimation( partitionedRestAnimation, 1.0, doRestingStuff_REST_TIME_PARTITION );
        }

        ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS, 1.0, doRestingStuff_REST_TIME_PARTITION );
        ActionDoCommand( RestMeUp(initialDamage) );
    }
}
///////////////////////////////// RESTING STUFF - end ////////////////////////


void main() {
    object oPC = GetLastPCRested();

    // Control de posibles bugs de invulnerabilidad
    if (GetPlotFlag(oPC)==TRUE && !GetIsDM(oPC)) {
        SendMessageToAllDMs("El personaje "+GetName(oPC)+" se encontraba invulnerable.");
        SetPlotFlag(oPC, FALSE);
        SisPremioCombate_quitarPorcentajeXpTransitoria( oPC, 100 );
    }

    if( GetLastRestEventType() == REST_EVENTTYPE_REST_STARTED && Experience_pasaControlYAjuste(oPC) ) {
        AssignCommand( oPC, ClearAllActions(FALSE) );

        Horses_onRest( oPC );

        if( GetLocalInt(oPC, "ArenaMode") )  //Nota por dragoncin: ZERO, CONSTANTES!
            return;


        // Modificacion por Dragoncin
        // Varita de suenio
        // Asigna una variable local al personaje con un TRUE o FALSE. Si vale TRUE, no lo deja descansar.
        // El valor lo asigna la Varita de suenio a todo un party.
        if( GetLocalInt(oPC, "DMNoPermiteDormir") ) {
            AssignCommand(oPC, ClearAllActions(FALSE));
            FloatingTextStringOnCreature("El DM no te permite descansar todavia. Espera su aprobacion para hacerlo.",oPC,FALSE);
            return;
        }


        int secondsSinceLastRest = Time_getSecondsSinceLastRest( oPC );
        if( secondsSinceLastRest > Time_SECONDS_BETWEEN_RESTS ) {
            AssignCommand( oPC, doRestingStuff_main() );
        } else {
            FloatingTextStringOnCreature( "No estas lo suficientemente cansado. Intenta otra vez en menos de " + IntToString(1+(Time_SECONDS_BETWEEN_RESTS - secondsSinceLastRest)/(60*Time_MINUTES_IN_AN_HOUR)) + " horas.", oPC, FALSE );
        }

        object memberIterator = GetFirstFactionMember( oPC, FALSE );
        while( memberIterator != OBJECT_INVALID ) {
            if(
                GetAssociateType(memberIterator) == ASSOCIATE_TYPE_HENCHMAN
                && GetMaster(memberIterator) == oPC
                && Time_getSecondsSinceLastRest( memberIterator ) > Time_SECONDS_BETWEEN_RESTS
            ) {
                AssignCommand( memberIterator, doRestingStuff_main() );
            }
            memberIterator = GetNextFactionMember( oPC, FALSE );
        }
    }
}

