//::///////////////////////////////////////////////
//:: Golden Ice Damage 1
//:: ravage_gldn_ice1
//:://////////////////////////////////////////////
/*
    1d6 Dex damage
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

	ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, d6(1) + nExtra, DURATION_TYPE_PERMANENT, TRUE);
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}