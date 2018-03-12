/*
   ----------------
   Warchief Tribal Frenzy
   
   prc_wchf_frenzy
   ----------------
*/

#include "prc_alterations"
#include "inc_addragebonus"

void FrenzyHB(object oPC, int nStr)
{
    //--------------------------------------------------------------------------
    // Check if the combat is over or if the PC turned it off
    //--------------------------------------------------------------------------
    if (!GetIsInCombat(oPC) || !GetLocalInt(oPC, "WarchiefFrenzy"))
    {
        return;
    }
        effect eDam;
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
		{
			// This is the damage they take for being in a frenzy
			eDam = EffectDamage(GetHitDice(oTarget));
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			
			effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nStr);
			eStr = ExtraordinaryEffect(eStr);
			int StrBeforeBonuses = GetAbilityScore(oTarget, ABILITY_STRENGTH);
			int ConBeforeBonuses = GetAbilityScore(oTarget, ABILITY_CONSTITUTION);
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oTarget, 6.5);
			// Because +10 is almost certain to hit the cap
			DelayCommand(0.1, GiveExtraRageBonuses(1, StrBeforeBonuses, ConBeforeBonuses, nStr, 0, 0, DAMAGE_TYPE_SLASHING, oTarget));
		}
		
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
	}
   
    // Power keeps doing till duration is over.
    DelayCommand(6.0f,FrenzyHB(oPC, nStr));
}

void main()
{
	object oPC = OBJECT_SELF;
	string nMes = "";
	
     	if(!GetHasSpellEffect(SPELL_TRIBAL_FRENZY))
     	{    
		int nWarChief = GetLevelByClass(CLASS_TYPE_WARCHIEF, oPC);
		int nBonus = 0;
	    
		if (nWarChief >= 9) nBonus = 10;
		else if (nWarChief >= 7) nBonus = 8;
		else if (nWarChief >= 5) nBonus = 6;
		else if (nWarChief >= 3) nBonus = 4;
		else if (nWarChief >= 1) nBonus = 2;
		
		FrenzyHB(oPC, nBonus);
     		nMes = "*Tribal Frenzy Activated*";
     		SetLocalInt(oPC, "WarchiefFrenzy", TRUE);
     	}
     	else     
     	{
		// Removes effects
		RemoveSpellEffects(SPELL_TRIBAL_FRENZY, oPC, oPC);
		nMes = "*Tribal Frenzy Deactivated*";
		DeleteLocalInt(oPC, "WarchiefFrenzy");
     	}
	
     	FloatingTextStringOnCreature(nMes, oPC, FALSE);	
}