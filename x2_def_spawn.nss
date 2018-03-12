//::///////////////////////////////////////////////
//:: Name x2_def_spawn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Default On Spawn script


2003-07-28: Georg Zoeller:

If you set a ninteger on the creature named
"X2_USERDEFINED_ONSPAWN_EVENTS"
The creature will fire a pre and a post-spawn
event on itself, depending on the value of that
variable
1 - Fire Userdefined Event 1510 (pre spawn)
2 - Fire Userdefined Event 1511 (post spawn)
3 - Fire both events

*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner, Georg Zoeller
//:: Created On: June 11/03
//:://////////////////////////////////////////////

const int EVENT_USER_DEFINED_PRESPAWN = 1510;
const int EVENT_USER_DEFINED_POSTSPAWN = 1511;

#include "RS_inc"
#include "x2_inc_switches"
#include "Speed_inc"
#include "Mercenario_inc"

void main() {
    // salvaguarda contra criaturas generadas en el fugue
    if( GetTag(GetArea(OBJECT_SELF)) == "fugue" && GetLocalInt( OBJECT_SELF, RS_nivelPremio_LN ) != 0 ) {
        WriteTimestampedLogEntry( "X2_def_spawn: error, criaturas llegaron al fugue" );
        DestroyObject(OBJECT_SELF);
        return;
    }

    // User defined OnSpawn event requested?
    int nSpecEvent = GetLocalInt(OBJECT_SELF,"X2_USERDEFINED_ONSPAWN_EVENTS");

    // Pre Spawn Event requested
    if (nSpecEvent == 1  || nSpecEvent == 3  )
    {
        SignalEvent(OBJECT_SELF,EventUserDefined(EVENT_USER_DEFINED_PRESPAWN ));
    }

    Speed_applyModifiedSpeed();

    // Ajusta la disciplina de la criatura
    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT
        ,EffectSkillIncrease(
            SKILL_DISCIPLINE
            , GetBaseAttackBonus(OBJECT_SELF) + 10 + GetAbilityModifier(ABILITY_STRENGTH, OBJECT_SELF) - GetSkillRank(SKILL_DISCIPLINE, OBJECT_SELF)
        )
        ,OBJECT_SELF
    );

    if( GetTag(OBJECT_SELF) == Mercenario_ES_DE_TABERNA_TAG ) { // modificado por Inquisidor porque como estaba nunca se complia la condicion del if
        ExecuteScript("nw_ch_ac9", OBJECT_SELF);
        Mercenario_prepararInventario();
    } else {
        // Execute default OnSpawn script.
        ExecuteScript("nw_c2_default9", OBJECT_SELF);
        NPC_prepararInventario();
    }
}
