//::///////////////////////////////////////////////
//:: Destruction Retribution
//:: prc_cc_desretrib.nss
//:://////////////////////////////////////////////
/*
    Causes all creatures whose masters have the feat to go boom.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 30 , 2005
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"

void main()
{

	SendMessageToPC(GetFirstPC(), "Creature has been killed");

	if (GetLocalInt(OBJECT_SELF, "DestructionRetribution"))
	{
	
		SendMessageToPC(GetFirstPC(), "Master has Destruction Retribution");
	
		int nDamage;
		int nHD = GetHitDice(OBJECT_SELF)/2;
		float fDelay;
		effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_10); //Replace with Negative Pulse
		effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
		effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
		effect eDam, eHeal;
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

		location lTarget = GetSpellTargetLocation();
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
		object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
		while (GetIsObjectValid(oTarget))
		{
			// d6 for every 2 HD
			int n = 0;
			for(n=1;n<nHD;n++)
			{
				nDamage += d6();
			} 
			// always does at least 1d6 damage.
			nDamage += d6();
			if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, 15, SAVING_THROW_TYPE_NEGATIVE))
			{
				nDamage /= 2;
			}
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
				eHeal = EffectHeal(nDamage);
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
			}
			else if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
				eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}

		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
		}
	}
}
