//::///////////////////////////////////////////////
//:: Baalzebul Summon 2
//:: prc_baal_sum2
//:://////////////////////////////////////////////
/*
    Summons a Double-Axe Wielding Devil
*/
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "x2_inc_spellhook"
void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables

    int nDuration = 15;
    effect eSummon = EffectSummonCreature("baalsummon2");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);


    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

