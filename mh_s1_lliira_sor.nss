//::///////////////////////////////////////////////
//:: Lliira' Aura: On Exit
//:: NW_S1_lliira_sor.ns
//:://////////////////////////////////////////////
/*
    Gere la sortie de la zone d'effet.
*/
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On:January , 2004
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
//SpawnScriptDebugger();
object oTarget =  GetExitingObject();
int test = SPELLABILITY_AURA_LLIIRA;
int eRemove = GetEffectSpellId(GetFirstEffect(oTarget));
//if (GetLocalInt(oTarget, "Lliira") == 1);
//ApplyEffectToObject(DURATION_TYPE_PERMANENT
    RemoveSpellEffects(SPELLABILITY_AURA_LLIIRA, GetAreaOfEffectCreator(), GetExitingObject());
}
