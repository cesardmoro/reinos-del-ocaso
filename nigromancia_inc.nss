///////////////////////
// 11/04/07 Script By Dragoncin
//
// Funciones para conjuros nigromanticos
//////////////////////

#include "x2_inc_itemprop"
#include "inventario_inc"
#include "Deity_Core"
#include "prc_inc_spells"

/////////////////////////// CONSTANTES //////////////////////////////////////
const string CommandUndead_lastCommanderCasterLevel_VN  = "CommUnd_lastCasterLvl";

const string DOTE_DESTRUCTION_RETRIBUTION       = "tieneDestructionRetribution";
const string CREADOR_NO_MUERTO                  = "animdead_creadorMuerto";

const string HD_CONTROLADOS_POR_ANIMATEDEAD     = "animdead_HDsControlados";

const string RESREF_UNDEAD_TRAITS               = "it_creitem003";

const string TIPO_TURN_UNDEAD_CLERIGO_NEUTRAL   = "turn_neutr_cleric";
const int TIPO_TURN_UNDEAD_EXPULSAR             = 1;
const int TIPO_TURN_UNDEAD_CONTROLAR            = 2;

const int SUBTIPO_GENERAL       = 0;
const int SUBTIPO_ZOMBIE        = 1;
const int SUBTIPO_ESQUELETO     = 2;

const int DOTE_EXTRA_INICIATIVA_MEJORADA        = 261; // Sacar de iprp_feats.2da

const string PREFIJO_RESREF_ESQUELETO    = "animdead_skel";
const string PREFIJO_RESREF_ZOMBIE       = "animdead_zomb";
const string PREFIJO_RESREF_ANIMDEAD     = "animdead_";

///////////////////////// FUNCIONES ////////////////////////////////////////

void aplicarUndeadTraits( object oCriatura, int subtipoUndead = SUBTIPO_GENERAL, int tamanioUndead = CREATURE_SIZE_MEDIUM, int nCorpsecrafter = FALSE, int nBolsterResistance = FALSE, int nDeadlyChill = FALSE, int nDestructionRetribution = FALSE, int nHardenedFlesh = FALSE, int nNimbleBones = FALSE );
void aplicarUndeadTraits( object oCriatura, int subtipoUndead = SUBTIPO_GENERAL, int tamanioUndead = CREATURE_SIZE_MEDIUM, int nCorpsecrafter = FALSE, int nBolsterResistance = FALSE, int nDeadlyChill = FALSE, int nDestructionRetribution = FALSE, int nHardenedFlesh = FALSE, int nNimbleBones = FALSE )
{
    if (GetLocalInt(oCriatura, ESTADO_EQUIPANDO_FORZADO)==EQUIPANDO_FORZADO_FUNCIONANDO)
        DelayCommand(1.0, aplicarUndeadTraits(oCriatura));
    else {
        // Si no tiene una piel propia, le creamos una
        object pielCriatura = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCriatura);
        if (!GetIsObjectValid(pielCriatura)) {
            pielCriatura = CreateItemOnObject(RESREF_UNDEAD_TRAITS, oCriatura);
            forzarEquiparItemRepetitivo(pielCriatura, oCriatura, INVENTORY_SLOT_CARMOUR);
        }
        // Si no tiene garras propias, le creamos unas
        string garraLresRef, garraRresRef;
        switch (tamanioUndead) {
            case CREATURE_SIZE_TINY:        garraLresRef = "prc_claw_1d6m_t";
                                            garraRresRef = "prc_claw_1d6m_t";
                                            break;
            case CREATURE_SIZE_SMALL:       garraLresRef = "prc_claw_1d6l_s";
                                            garraRresRef = "prc_claw_1d6l_s";
                                            break;
            case CREATURE_SIZE_MEDIUM:      garraLresRef = "prc_claw_1d6m_m";
                                            garraRresRef = "prc_claw_1d6m_m";
                                            break;
            case CREATURE_SIZE_LARGE:       garraLresRef = "prc_claw_1d6m_l";
                                            garraRresRef = "prc_claw_1d6m_l";
                                            break;
            case CREATURE_SIZE_HUGE:        garraLresRef = "prc_claw_1d6m_h";
                                            garraRresRef = "prc_claw_1d6m_h";
                                            break;
        }
        object garraLCriatura = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCriatura);
        if (!GetIsObjectValid(garraLCriatura)) {
            garraLCriatura = CreateItemOnObject( garraLresRef, oCriatura );
            AssignCommand( oCriatura, ActionEquipItem(garraLCriatura, INVENTORY_SLOT_CWEAPON_L) );
        }
        object garraRCriatura = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCriatura);
        if (!GetIsObjectValid(garraLCriatura)) {
            garraRCriatura = CreateItemOnObject( garraRresRef, oCriatura );
            AssignCommand( oCriatura, ActionEquipItem(garraRCriatura, INVENTORY_SLOT_CWEAPON_R) );
        }


        // Razgos basicos de un Undead
        IPSafeAddItemProperty(pielCriatura, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS));
        IPSafeAddItemProperty(pielCriatura, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC));
        IPSafeAddItemProperty(pielCriatura, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE));
        IPSafeAddItemProperty(pielCriatura, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN));
        IPSafeAddItemProperty(pielCriatura, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS));
        IPSafeAddItemProperty(pielCriatura, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS));
        IPSafeAddItemProperty(pielCriatura, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON));
        IPSafeAddItemProperty(pielCriatura, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB));

        // Razgos por tipo de Undead
        if (subtipoUndead==SUBTIPO_ZOMBIE) {
            IPSafeAddItemProperty(pielCriatura, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGERESIST_5));
            IPSafeAddItemProperty(pielCriatura, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGERESIST_5));
        } else if (subtipoUndead == SUBTIPO_ESQUELETO) {
            IPSafeAddItemProperty(pielCriatura, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_PIERCING, IP_CONST_DAMAGERESIST_10));
            IPSafeAddItemProperty(pielCriatura, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SLASHING, IP_CONST_DAMAGERESIST_5));
            IPSafeAddItemProperty(pielCriatura, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEIMMUNITY_100_PERCENT));
        }

        // Razgos por dotes del creador
        if (nCorpsecrafter)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, 4)), oCriatura);
        if (nBolsterResistance)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectTurnResistanceIncrease(4)), oCriatura);
        if (nDeadlyChill) {
            AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6), garraLCriatura );
            AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEBONUS_1d6), garraRCriatura );
        }
        if (nNimbleBones)
            IPSafeAddItemProperty(pielCriatura, ItemPropertyBonusFeat(DOTE_EXTRA_INICIATIVA_MEJORADA));

        // Bonus de AC por tamaño del no muerto
        int bonusAC = (nHardenedFlesh) ? 2 : 0;
        switch (tamanioUndead) {
            case CREATURE_SIZE_SMALL:       bonusAC += 1; break;
            case CREATURE_SIZE_MEDIUM:      bonusAC += 2; break;
            case CREATURE_SIZE_LARGE:       bonusAC += 2; break;
            case CREATURE_SIZE_HUGE:        bonusAC += 3; break;
        }
        if (bonusAC > 0)
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectACIncrease(bonusAC, AC_NATURAL_BONUS)), oCriatura);
    }
}

// Copia la velocidad de la criatura A en la criatura B
// Devuelve -1 en caso de error, 0 en caso de que alguna de las criaturas estuviese inmovil o tuviera velocidad de DM
// (en esos casos no hace nada) y el porcentaje de incremento o decremento correspondiente
int copiarVelocidad( object criaturaA, object criaturaB, int nNimbleBones = FALSE );
int copiarVelocidad( object criaturaA, object criaturaB, int nNimbleBones = FALSE )
{
    int rangoMovimientoA = GetMovementRate(criaturaA);
    int rangoMovimientoB = GetMovementRate(criaturaB);

    float velocidadA;
    switch (rangoMovimientoA) {
        case 1:         return 0; break;
        case 2:         velocidadA = 1.5; break;
        case 3:         velocidadA = 2.5; break;
        case 4:         velocidadA = 3.5; break;
        case 5:         velocidadA = 4.5; break;
        case 6:         velocidadA = 5.5; break;
        case 7:         return 0; break;
        default:        return -1; break;
    }
    float velocidadB;
    switch (rangoMovimientoB) {
        case 1:         return 0; break;
        case 2:         velocidadB = 1.5; break;
        case 3:         velocidadB = 2.5; break;
        case 4:         velocidadB = 3.5; break;
        case 5:         velocidadB = 4.5; break;
        case 6:         velocidadB = 5.5; break;
        case 7:         return 0; break;
        default:        return -1; break;
    }

    // Bonus de 10.0 a la velocidad por dote
    if (nNimbleBones)
        velocidadA += 1.0;

    int cambioVelocidad;
    float porcentajeDiferencia = velocidadA / velocidadB;
    if (porcentajeDiferencia > 1.0) {
        cambioVelocidad = FloatToInt((porcentajeDiferencia-1.0) * 100);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedIncrease(cambioVelocidad)), criaturaB);
        return cambioVelocidad;
    } else {
        cambioVelocidad = FloatToInt(porcentajeDiferencia * 100);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectMovementSpeedDecrease(cambioVelocidad)), criaturaB);
        return -cambioVelocidad;
    }
}

// Ejecuta la accion de DestructionRetribution
// Debe agregarse en el evento OnDeath del no-muerto
/*
    Type of Feat: General
    Prerequisite: Corpsecrafter
    Specifics: Each undead you raise or create with any necromancy spell releases a burst of negative energy upon its destruction, dealing 1d6 points of damage plus an additional 1d6 per 2 Hit Dice to every creature within a 10 foot spread (Reflex DC 15 half). Undead are healed by this damage.
    Use: Automatic.
*/
void DoDestructionRetribution( object oDead, object oMaster );
void DoDestructionRetribution( object oDead, object oMaster )
{
    int dadosDanio = 1 + GetHitDice( oDead ) / 2;
    location deadLocation = GetLocation( oDead );

    effect eVis = EffectVisualEffect( VFX_FNF_LOS_EVIL_10 );
    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, deadLocation );

    object objetoIterado = GetFirstObjectInShape( SHAPE_SPHERE, 10.0, deadLocation );
    int nDamage = 0;
    effect eDamage;
    while (GetIsObjectValid( objetoIterado ))
    {
        if (GetRacialType( objetoIterado ) == RACIAL_TYPE_UNDEAD)
        {
            eDamage = EffectHeal(d6(dadosDanio));
            eDamage = EffectLinkEffects( eDamage, EffectVisualEffect(VFX_IMP_HEALING_M) );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, objetoIterado );
        }
        else if ( objetoIterado != oMaster )
        {
            nDamage = PRCGetReflexAdjustedDamage( d6(dadosDanio), objetoIterado, 15, SAVING_THROW_TYPE_NEGATIVE );
            if (nDamage > 0)
            {
                eDamage = EffectDamage( nDamage, DAMAGE_TYPE_NEGATIVE );
                eDamage = EffectLinkEffects( eDamage, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY) );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, objetoIterado );
            }
        }
        objetoIterado = GetNextObjectInShape( SHAPE_SPHERE, 10.0, deadLocation );
    }
}

// Devuelve si alguna deidad permite o no lanzar un conjuro nigromantico
int deidadPermiteLanzarConjurosNigromanticos( object oCaster = OBJECT_SELF );
int deidadPermiteLanzarConjurosNigromanticos( object oCaster = OBJECT_SELF )
{
    int puedeLanzarConjuro = TRUE;
    if (GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) > 0) {
        int nDeity = GetDeityIndex(oCaster);
        string nombreDeidad = GetDeityName(nDeity);
        if ((GetDeityAlignmentGE(nDeity) == ALIGNMENT_GOOD) || (nombreDeidad=="Kelemvor") || (nombreDeidad=="Silvanus") || (nombreDeidad=="Yelmo")) {
            SendMessageToPC(oCaster, nombreDeidad+" no te permite lanzar este conjuro!");
            puedeLanzarConjuro = FALSE;
        }
    }
    return puedeLanzarConjuro;
}

int Nigromancia_getHasAnimateDead( object oPC );
int Nigromancia_getHasAnimateDead( object oPC )
{
    return ( GetHasSpell( SPELL_ANIMATE_DEAD, oPC ) ||
             GetHasFeat( FEAT_ANIMATE_DEAD, oPC )
            );
}

// Devuelve el creador del esqueleto o zombie animado
// Reemplaza el uso de GetMaster() porque esta no funciona en onDeath
object GetAnimatedDeadMaster( object oAnimatedDead );
object GetAnimatedDeadMaster( object oAnimatedDead )
{
    return GetLocalObject( oAnimatedDead, CREADOR_NO_MUERTO );
}

const string Nigromancia_hayNigromanteEnArea_VN = "haynigromante";

void Nigromancia_onAreaEnter( object oPC );
void Nigromancia_onAreaEnter( object oPC )
{
    if (Nigromancia_getHasAnimateDead( oPC )) {
        SetLocalInt( GetArea(oPC), Nigromancia_hayNigromanteEnArea_VN, TRUE );
    }
}

void Nigromancia_onAreaExit( object oPC );
void Nigromancia_onAreaExit( object oPC )
{
    int numeroNigromantes = 0;
    object leftArea = GetArea( oPC );
    object objetoIterado = GetFirstObjectInArea( leftArea );
    while (GetIsObjectValid( objetoIterado )) {
        if (GetIsPC( objetoIterado )) {
            if ( Nigromancia_getHasAnimateDead( objetoIterado ) ) {
                numeroNigromantes++;
            }
        }
        objetoIterado = GetNextObjectInArea( leftArea );
    }
    if ( numeroNigromantes == 0) {
        SetLocalInt( GetArea(oPC), Nigromancia_hayNigromanteEnArea_VN, FALSE );
    }
}

// Para ser llamada desde el evento OnDeath de los No Muertos Animados
void AnimateDead_onDeath( object noMuerto = OBJECT_SELF );
void AnimateDead_onDeath( object noMuerto = OBJECT_SELF )
{
    if (GetStringLeft(GetResRef(noMuerto), GetStringLength(PREFIJO_RESREF_ANIMDEAD)) == PREFIJO_RESREF_ANIMDEAD )
    {
        object oMaster = GetAnimatedDeadMaster( noMuerto );

        if ( GetHasFeat( FEAT_DESTRUCTION_RETRIBUTION, oMaster ) )
        {
            // Aplicacion de la dote Destruction Retribution
            DoDestructionRetribution( noMuerto, oMaster );
        }

        SetIsDestroyable(TRUE, FALSE);
        DestroyObject(noMuerto, 0.2);
    }
}
