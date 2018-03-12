#include "PenaPorPerdon"
#include "prc_class_const"
#include "SPC_inc"
#include "Muerte_inc"
#include "Mercenario_inc"
#include "Time_inc"
#include "IPS_Pj_inc"
//#include "inc_eventHook"


void aplicarModificaciones( object oPC ) {

    // agregua el feat 98 (¡¡¡pone nombres a las constantes!!!).
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(98), GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC) );

    //Aplica el bonificador de disciplina.
    AddItemProperty(
        DURATION_TYPE_PERMANENT,
        ItemPropertySkillBonus(
            SKILL_DISCIPLINE,
            GetBaseAttackBonus(oPC)+10+GetAbilityModifier(ABILITY_STRENGTH, oPC) - GetSkillRank(SKILL_DISCIPLINE, oPC)
        ),
        GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC)
    );
    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(SupernaturalEffect(EffectSkillIncrease(SKILL_DISCIPLINE, (GetBaseAttackBonus(oPC)+10+GetAbilityModifier(ABILITY_STRENGTH, oPC) - GetSkillRank(SKILL_DISCIPLINE, oPC))))),oPC);

    //Baja la puntuacion de Pick Pocket.
    AddItemProperty(
        DURATION_TYPE_PERMANENT,
        ItemPropertyDecreaseSkill(SKILL_PICK_POCKET, 10),
        GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)
    );

    // pone al máximo la reputacion de la facción Druida hacia el personaje.
    if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0)
        AdjustReputation(oPC, GetObjectByTag("Druida"),100);

    //Reduccion del fallo arcano de las clases Bardo y Minstrel of the Edge.
    if (GetLevelByClass(CLASS_TYPE_MINSTREL_EDGE, oPC) > 0)
    {
        //Si es Minstrel y (Mago o Hechicero), puede usar armaduras ligerass sin fallo arcano
        if ( (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) > 0) || (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) > 0) )
            DelayCommand(3.0, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT) , GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)));
        //Si es Minstrel y no es Mago ni Hechicero, puede usar armaduras mediass sin fallo arcano
        else
            DelayCommand(3.0, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT) , GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)));
    } else if (GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0) {
        //si es Bardo y no es Mago ni Hechicero, puede usar armaduras ligeras sin fallo arcano
        if ( (GetLevelByClass(CLASS_TYPE_WIZARD, oPC) == 0) && (GetLevelByClass(CLASS_TYPE_SORCERER, oPC) == 0) )
            DelayCommand(3.0, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT) , GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)));
    }


    // le da bonus de AC al monk.
    int acb = abs(GetLevelByClass(CLASS_TYPE_MONK, oPC)/4);
    if(GetLevelByClass(CLASS_TYPE_MONK, oPC) > 3) {
        AddItemProperty(
            DURATION_TYPE_PERMANENT,
            ItemPropertyACBonus(acb),
            GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)
        );
    }
}


// se asume que OBJECT_SELF es el personaje en penitencia
void finalizarPenitencia( object pc ) {
    // si el personaje termina su penitencia en el fugue
    if( GetTag(GetArea(pc)) == "fugue" )
        FloatingTextStringOnCreature( "Tu penitencia ha culminado. Habla con la estatua si pretendes revivir.", pc, FALSE );
}


void main() {
    object oPC = GetEnteringObject();
    if (GetIsPC(oPC)) {
        string pcId = GetStringLeft( GetName(oPC), 25 );

        //Borra todos los cuerpos que estuviese cargando el personaje muerto
        Muerte_destruirCuerposCargados(oPC);

        // Programa la duracion de la penitencia
        string penitenciaFechaFinRef = Muerte_Penitencia_fechaFin_MVP + pcId;
        // Nota: la fecha de finalizacion de la penitencia se usa además como marca de que la penitencia esta en curso.
        if( GetLocalInt( GetModule(), penitenciaFechaFinRef ) != 0 ) {
            int faltantePenitencia =  GetLocalInt( GetModule(), penitenciaFechaFinRef ) - Time_secondsSince1300();
            if( faltantePenitencia <= 0 )
                finalizarPenitencia(oPC);
            else
                DelayCommand( IntToFloat(faltantePenitencia), finalizarPenitencia(oPC) );
        }
        else {
            int duracionPenitencia = getPenaEspera( pcId, oPC );
            SetLocalInt( GetModule(), penitenciaFechaFinRef, duracionPenitencia + Time_secondsSince1300() );
            DelayCommand( IntToFloat(duracionPenitencia), finalizarPenitencia(oPC) );
        }

        //Exporta el personaje
        SetLocalInt( oPC, "isExportPending", TRUE ); // Hace que se exporte el PJ en el proximo heartbeat.

        //Hace invulnerable al PJ para evitar muertes en el fugue
        SetPlotFlag(oPC, TRUE);
        // Con el mismo espiritu, les impedimos lanzar conjuros
        AssignCommand( GetArea(oPC), ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectSpellFailure(100), oPC ) );

        // actualizar la posicion del personaje por las dudas el PJ desloguee antes que sea actualizada por el heartbeat
        SetLocalLocation( oPC, "locacionPC", GetLocation(oPC) );

        // desequipar todos los ítems para promover que no vuelva a la vida con ítems malditos.
        if( !GetIsDM( oPC ) )
            AssignCommand( oPC, IPS_Pj_onFugueEnter() );

        // TODO: Descomentar cuando se termine la renovacion del módulo
        //ExecuteAllScriptsHookedToEvent( oPC, EVENT_ONPLAYERRESPAWN );

        aplicarModificaciones( oPC ); //Nota por Inquisidor: ¿Porque demonios esta esto acá? Moverlo a uno de los Scripts Hooked To EVENT_ONPLAYERRESPAWN

        SendMessageToPC(oPC, "Olvidas todo lo que sucedio desde tu último descanso");

    } else if( GetLocalInt( oPC, RS_nivelPremio_LN ) != 0 ) {
        // salvaguarda contra criaturas generadas en el fugue
        WriteTimestampedLogEntry( "X2_def_spawn: error, el RS genero criatura en el fugue" );
        DestroyObject(oPC);

    } else if( GetLocalInt( oPC, "merc" ) ) { // Destruye los mercenarios que entren al fugue
        DestroyObject(oPC);
    }

}
