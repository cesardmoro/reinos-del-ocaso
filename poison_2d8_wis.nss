//:://////////////////////////////////////////////
//:: Poison: 2d8 Wisdom damage
//:: poison_2d8_wis
//:://////////////////////////////////////////////
/** @file
    This is one of the scripts that implement causing
    poison ability damage using the ApplyAbilityDamage()
    wrapper.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 01.08.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_abil_damage"

void main()
{
    object oTarget = OBJECT_SELF;
    int nDamage = d8(2);
    int nAbility = ABILITY_WISDOM;

    ApplyAbilityDamage(oTarget, nAbility, nDamage, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
}
