/*
	Ollam's Inspire Resilience
*/

#include "spinc_common"

void main()
{
	object oTarget = PRCGetSpellTargetObject();
	effect eVis = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
	
    	if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_DWARF)
    	{
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 5), oTarget, 60.0);
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageResistance(DAMAGE_TYPE_PIERCING, 5), oTarget, 60.0);
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5), oTarget, 60.0);
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_FORT, 4), oTarget, 60.0);
    	}
    	else
    	{
    		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_FORT, 2), oTarget, 60.0);
    		DelayCommand(60.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, CreateDoomEffectsLink(), oTarget, 60.0));
    	}
    	
    	SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}

