#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
  
	SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);
	
	// Get the target and raise the spell cast event.
	object oTarget = GetSpellTargetObject();
	SPRaiseSpellCastAt(oTarget, FALSE);
      
      if(GetHasSpellEffect(SPELL_GREATER_HEROISM, oTarget))
      {
              FloatingTextStringOnCreature("Target already has Greater Heroism Affect!", OBJECT_SELF);
              SPSetSchool();
              return;
      }

	// Determine the spell's duration, taking metamagic feats into account.
	int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
	float fDuration = SPGetMetaMagicDuration(TenMinutesToSeconds(nCasterLvl));
	
	// Create the chain of buffs to apply, including the vfx.
	effect eBuff = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL);
	eBuff = EffectLinkEffects (eBuff, EffectAttackIncrease(2, ATTACK_BONUS_MISC));
	eBuff = EffectLinkEffects (eBuff, EffectSkillIncrease(SKILL_ALL_SKILLS, 2));
	
	SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLvl
);
	SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_LESSER), oTarget);
	
	SPSetSchool();
}
