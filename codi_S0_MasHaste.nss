//::///////////////////////////////////////////////
//:: Warpriest
//:: MassHaste
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_WARPRIEST);
    int nDC    = GetLevelByClass(CLASS_TYPE_WARPRIEST) + GetAbilityModifier(ABILITY_CHARISMA) + 10; 
    DoRacialSLA(SPELL_MASS_HASTE, nLevel, nDC);
}

