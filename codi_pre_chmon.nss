//::///////////////////////////////////////////////
//:: codi_pre_chmon
//:://////////////////////////////////////////////
/*
     Ocular Adept: Charm Monster
*/
//:://////////////////////////////////////////////
//:: Created By: James Stoneburner
//:: Created On: 2003-11-30
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_OCULAR);
    if (DEBUG) FloatingTextStringOnCreature("Your Ocular Adept class level is: " + IntToString(nLevel), OBJECT_SELF);
    int nDC = 10 + (nLevel/2) + GetAbilityModifier(ABILITY_CHARISMA);
    if (DEBUG) FloatingTextStringOnCreature("Your Ocular Adept DC is: " + IntToString(nDC), OBJECT_SELF);
    DoSpellRay(SPELL_CHARM_MONSTER, nLevel, nDC);
}
