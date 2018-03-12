//::///////////////////////////////////////////////
//:: Hathran
//:: Fear
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "x2_inc_spellhook"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_HATHRAN);
    int nDC    = GetLevelByClass(CLASS_TYPE_HATHRAN) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_FEAR, nLevel, nDC);
}

