/*******************************************************************************
 Script By Dragoncin

 Spell Include de Reinos del Ocaso

 Utilidad: principalmente incluye funciones con criaturas para asignar efectos
 Esto permite remover especificamente los efectos creados por ellas, de manera de poder hacer que los
 conjuros no apilen los efectos creados por el mismo creador.

 Este método es usado por el PRC, pero dada la mezcla de versiones es casi imposible de usar las funciones del PRC.
 Por ende me resultó más facil crearlas.
 A diferencia de las funciones del PRC, cuando la locacion donde un Creador se crearía no existe,
 el Creador no se crea. En el PRC se crea en la StartingLocation.
*******************************************************************************/

#include "rdo_spell_const"
#include "prc_class_const"

const string RdO_NO_CREAR_CADAVER_AL_MORIR = "RdO_NO_CREAR_CADAVER_AL_MORIR";

const string RDO_EffectCreators_WAYPOINT = "RDO_EffectCreators_WAYPOINT";
const string RdO_EffectCreator_RESREF    = "rdo_effcreator";

// Devuelve una criatura del Area de Servicio - Creadores destinada a crear un tipo de efectos
// Sirve para remover todos los efectos creados por esa criatura
object RDO_GetCreatorByTag( string creatorTag );
object RDO_GetCreatorByTag( string creatorTag )
{
    object oModule = GetModule();
    object effectCreator = GetLocalObject(oModule, creatorTag);
    if (!GetIsObjectValid(effectCreator)) {
        effectCreator = GetObjectByTag(creatorTag);
        if (!GetIsObjectValid(effectCreator)) {
            object effectCreatorsWaypoint = GetWaypointByTag(RDO_EffectCreators_WAYPOINT);
            if (GetIsObjectValid(effectCreatorsWaypoint))
                effectCreator = CreateObject(OBJECT_TYPE_CREATURE, RdO_EffectCreator_RESREF, GetLocation(effectCreatorsWaypoint), FALSE, creatorTag);
            else {
                SendMessageToAllDMs("[ERROR] RDO_GetCreatorByTag: no se pudo crear el Creador.");
                WriteTimestampedLogEntry("[ERROR] RDO_GetCreatorByTag: no se pudo crear el Creador.");
                return OBJECT_INVALID;
            }
        }
        SetLocalObject(oModule, creatorTag, effectCreator);
    }

    return effectCreator;
}

//Devuelve la criatura asignada para crear los efectos del conjuro dado
//Si no la encuentra, la crea en el lugar prefijado (si existe el waypoint
/*object RDO_GetSpellEffectCreator( int nSpell );
object RDO_GetSpellEffectCreator( int nSpell )
{
    string identificadorCreador;
    switch (nSpell) {
        case SPELL_ELEMENTAL_SHIELD_FIRE:       identificadorCreador = SP_ElemShield_EFFECT_CREATOR; break;
        case SPELL_ELEMENTAL_SHIELD_COLD:       identificadorCreador = SP_ElemShield_EFFECT_CREATOR; break;
        default:                                return OBJECT_INVALID;
    }

    object effectCreator = RDO_GetCreatorByTag(identificadorCreador);

    return effectCreator;
}*/


//Quita a oPC los efectos creados por oCreator
void RDO_RemoveEffectsByCreator( object oPC, object oCreator );
void RDO_RemoveEffectsByCreator( object oPC, object oCreator )
{
    effect efectoIterado = GetFirstEffect(oPC);
    while (GetIsEffectValid(efectoIterado)) {
        if (GetEffectCreator(efectoIterado)==oCreator) {
            RemoveEffect(oPC, efectoIterado);
        }
        efectoIterado = GetNextEffect(oPC);
    }
}

// Devuelve un efecto de Shaken
// A shaken character takes a –2 penalty on attack rolls, saving throws, skill checks, and ability checks.
// Shaken is a less severe state of fear than frightened or panicked.
effect EffectShaken();
effect EffectShaken()
{
    effect eShaken = EffectAttackDecrease(2);
    eShaken = EffectLinkEffects(eShaken, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2));
    int i;
    for (i=0; i<50; i++) {
        eShaken = EffectLinkEffects(eShaken, EffectSkillDecrease(i, 2));
    }
    eShaken = EffectLinkEffects(eShaken, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));
    return eShaken;
}
