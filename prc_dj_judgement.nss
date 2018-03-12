//::///////////////////////////////////////////////
//:: Drow Judicator
//:: Judgement
//:://////////////////////////////////////////////
//:: Horrid Wilting type effect
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_JUDICATOR);
    int nDC    = GetLevelByClass(CLASS_TYPE_JUDICATOR) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_HORRID_WILTING, nLevel, nDC);
}

