/*
    Psionic OnHit.
    This scripts holds all functions used for psionics on hit powers and abilities.

    Stratovarius
*/

// Include Files:
#include "psi_inc_psifunc"
#include "X0_I0_SPELLS"
#include "psi_inc_pwresist"
#include "prc_inc_combat"



// Does the strength drain and application for Strength of my Enemy
void StrengthEnemy(object oCaster, object oTarget);

// Swings at the target closest to the one hit
void SweepingStrike(object oCaster, object oTarget);

// ---------------
// BEGIN FUNCTIONS
// ---------------

void StrengthEnemy(object oCaster, object oTarget)
{
	// No point in doing any of this if the target is immune
	if (GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE)) return;

	// Max that can be applied
	int nMax = GetLocalInt(oCaster, "StrengthEnemyMax");
	// Damage done to the target before by this power
	int nDamage = GetLocalInt(oTarget, "StrengthEnemyDamage");
	// Current bonus of the manifester
	int nBonus = GetLocalInt(oCaster, "StrengthEnemyBonus");
	// Duration the power has left to run
	int nDur = GetLocalInt(oCaster, "StrengthEnemyRound");
	// Caster level incase he gets dispelled
	int nCaster = GetLocalInt(oCaster, "StrengthEnemyCaster");


	// Apply the damage
	ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, 1, DURATION_TYPE_TEMPORARY, TRUE, HoursToSeconds(24));

	// Keep track of how many times we've drained the person, which is one more than previous
	nDamage += 1;
	SetLocalInt(oTarget, "StrengthEnemyDamage", nDamage);

	if (nDamage > nBonus)
	{
		// Makes sure the bonus cant pass the maximum
		if (nBonus > nMax) nBonus = nMax;
		effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nBonus);
		effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
		effect eLink = EffectLinkEffects(eVis, eStr);
		SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur),TRUE,-1,nCaster);
	}

	// Clean up all ints on the target when the power is over
	DelayCommand(RoundsToSeconds(nDur), DeleteLocalInt(oTarget, "StrengthEnemyDamage"));
}

void SweepingStrike(object oCaster, object oTarget)
{
	// Use the function to get the closest creature as a target
	object oStrikeTarget = GetNearestCreatureToLocation(CREATURE_TYPE_IS_ALIVE, TRUE, GetLocation(oTarget));
	// If he's in a place that can be reached and he's standing adjacent to the original target
	if (GetIsInMeleeRange(oStrikeTarget, oCaster) && GetIsInMeleeRange(oStrikeTarget, oTarget))
	{
		effect eVis = EffectVisualEffect(VFX_IMP_STUN);
		PerformAttack(oStrikeTarget, oCaster, eVis, 0.0, 0, 0, 0, "Sweeping Strike Hit", "Sweeping Strike Miss");
	}
}