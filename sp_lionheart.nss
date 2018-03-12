/////////////////////////////////////////////////////////////////////
//
// Lionheart - Target becomes immune to fear.
//
/////////////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;

	SPSetSchool(SPELL_SCHOOL_ABJURATION);

	// Get the target and raise the spell cast event.
	object oTarget = GetSpellTargetObject();
	SPRaiseSpellCastAt(oTarget, FALSE);

	// Determine the spell's duration, taking metamagic feats into account.
	int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
	float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nCasterLvl));

	// Apply the buff and vfx.
	effect eBuff = EffectImmunity(IMMUNITY_TYPE_FEAR);
	eBuff = EffectLinkEffects(eBuff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLvl
);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_LESSER), oTarget);

	SPSetSchool();
}
