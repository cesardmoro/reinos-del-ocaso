#include "spinc_common"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_CONJURATION);

	object oTarget = GetSpellTargetObject();
	
	
	
	if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		// Fire cast spell at event for the specified target
		SPRaiseSpellCastAt(oTarget);
		
		int CasterLvl = PRCGetCasterLevel();

		if (!SPResistSpell(OBJECT_SELF, oTarget,CasterLvl+SPGetPenetr()))
		{
			// Make touch attack, saving result for possible critical
			int nTouchAttack = TouchAttackRanged(oTarget);
			if (nTouchAttack > 0)
			{
				// Impact vfx.
				SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
					EffectVisualEffect(VFX_IMP_ACID_S), oTarget);
						
				if (!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, SPGetSpellSaveDC(oTarget,OBJECT_SELF), 
					SAVING_THROW_TYPE_SPELL))
				{
					float fDuration = SPGetMetaMagicDuration(MinutesToSeconds(CasterLvl));
					
					// Target cannot move no matter what.
					effect eEffect = EffectCutsceneImmobilize();
					eEffect = EffectLinkEffects(eEffect,
						EffectVisualEffect(VFX_DUR_GLOW_LIGHT_GREEN));
					SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration,TRUE,-1,CasterLvl);

					// If target is medium or smaller may not take any actions either.						
					if (GetCreatureSize(oTarget) <= CREATURE_SIZE_MEDIUM)
						SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectParalyze(), 
							oTarget, fDuration,TRUE,-1,CasterLvl);
				}
				else
				{
					// Show that the target made it's save.
					SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
						EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE), oTarget);
				}
			}
		}
	}
	
	SPSetSchool();
}
