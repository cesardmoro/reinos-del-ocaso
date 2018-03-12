//::///////////////////////////////////////////////
//:: Jade Water Damage 2
//:: ravage_jade_wtr2
//:://////////////////////////////////////////////
/*
    1d4 Int damage and 1d4 Wis damage
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
//:://////////////////////////////////////////////


#include "spinc_common"
#include "inc_ravage"

void main()
{
	object oTarget = OBJECT_SELF;
	// Ravages only affect evil creatures
	if (GetAlignmentGoodEvil(oTarget)!=ALIGNMENT_EVIL) return;
	int nExtra = GetRavageExtraDamage(oTarget);
	effect eVis = GetRavageVFX();

	ApplyAbilityDamage(oTarget, ABILITY_WISDOM,       d4(1) + nExtra, DURATION_TYPE_PERMANENT, TRUE);
	ApplyAbilityDamage(oTarget, ABILITY_INTELLIGENCE, d4(1) + nExtra, DURATION_TYPE_PERMANENT, TRUE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}