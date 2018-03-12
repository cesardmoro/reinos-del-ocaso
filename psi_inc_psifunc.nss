/* 
   ----------------
   prc_psi_ppoints
   ----------------
   
   19/10/04 by Stratovarius
   
   Calculates the Manifester level, DC, etc.
   Psion, Psychic Warrior, Wilder. (Soulknife does not have Manifester levels)
*/

#include "prc_feat_const"
#include "prc_class_const"
#include "lookup_2da_spell"

// Returns the Manifesting Class
int GetManifestingClass(object oCaster = OBJECT_SELF);

// Returns Manifester Level
int GetManifesterLevel(object oCaster = OBJECT_SELF);

// Checks to see if it is a Psychic Warrior
// Power with a power level lower than its level
// for Psion/Wilder.
int PsychicWarriorLevel(int nSpell);

// Returns the level of a Power
// Used for Power cost and DC
int GetPowerLevel();

// Returns the psionic DC
int GetManifesterDC(object oCaster = OBJECT_SELF);

// Checks whether manifester has enough PP to cast
// If he does, subtract PP and cast power, else power fails
int GetCanManifest(object oCaster, int nAugCost, object oTarget = OBJECT_SELF);

// Checks to see if the caster has suffered psychic enervation
// from a wild surge. If yes, daze and subtract power points.
// Also checks for Surging Euphoria, and applies it, if needed.
void PsychicEnervation(object oCaster, int nWildSurge);

// Checks to see if the power manifested is a Telepathy one
// This is used with the Wilder's Volatile Mind ability.
int GetIsTelepathyPower();

// Increases the cost of a Telepathy power by an 
// amount if the target of the spell is a Wilder
int VolatileMind(object oTarget, object oCaster);

// ---------------
// BEGIN FUNCTIONS
// ---------------


int GetManifestingClass(object oCaster)
{

	int nPsion = GetLevelByClass(CLASS_TYPE_PSION, oCaster);
	int nPsychic = GetLevelByClass(CLASS_TYPE_PSYWARRIOR, oCaster);
	int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oCaster);
	int nClass;
	int nLevel = GetCasterLevel(oCaster);
	
	if (nLevel == nPsion)	 	nClass = CLASS_TYPE_PSION;
	else if (nLevel == nWilder) 	nClass = CLASS_TYPE_WILDER;
	else if (nLevel == nPsychic) 	nClass = CLASS_TYPE_PSYWARRIOR;
	
	FloatingTextStringOnCreature("Manifesting Class: " + IntToString(nClass), oCaster, FALSE);	
	
	return nClass;

}

int GetManifesterLevel(object oCaster)
{
	//Gets the level of the manifesting class
	int nLevel = GetCasterLevel(oCaster);
	int nSurge = GetLocalInt(oCaster, "WildSurge");
	
	if (nSurge > 0) nLevel = nLevel + nSurge;
	
	//FloatingTextStringOnCreature("Manifester Level: " + IntToString(nLevel), oCaster, FALSE);

	return nLevel;
}


int PsychicWarriorLevel(int nSpell)
{
	if (nSpell == 2372 || nSpell == 2377)
	{
		return TRUE;
	}
	
	return FALSE;
}

int GetPowerLevel()
{
	int nSpell = GetSpellId();
	int nLevel = StringToInt(lookup_spell_innate(nSpell));
	int nPsychic = PsychicWarriorLevel(nSpell);
	if (nPsychic) nLevel -= 1;
	return nLevel;
}


int GetManifesterDC(object oCaster)
{

	int nClass = GetManifestingClass(oCaster);
	int nDC = 10;
	nDC = nDC + GetPowerLevel();
	
	if (nClass == CLASS_TYPE_PSION)			nDC = nDC + GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
	else if (nClass == CLASS_TYPE_WILDER)		nDC = nDC + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	else if (nClass == CLASS_TYPE_PSYWARRIOR)	nDC = nDC + GetAbilityModifier(ABILITY_WISDOM, oCaster);

	return nDC;
}

int GetCanManifest(object oCaster, int nAugCost, object oTarget = OBJECT_SELF)
{
    int nLevel = GetPowerLevel();
    int nAugment = GetLocalInt(oCaster, "Augment");
    int nPP = GetLocalInt(oCaster, "PowerPoints");
    int nPPCost;
    int nCanManifest = TRUE;
    int nVolatile = VolatileMind(oTarget, oCaster);
    
    //Sets Power Point cost based on power level
    if (nLevel == 1) nPPCost = 1;
    else if (nLevel == 2) nPPCost = 3;
    else if (nLevel == 3) nPPCost = 5;
    else if (nLevel == 4) nPPCost = 7;
    else if (nLevel == 5) nPPCost = 9;
    else if (nLevel == 6) nPPCost = 11;
    else if (nLevel == 7) nPPCost = 13;
    else if (nLevel == 8) nPPCost = 15;
    else if (nLevel == 9) nPPCost = 17;
    
    //Adds in the augmentation cost
    if (nAugment > 0) nPPCost = nPPCost + (nAugCost * nAugment); 
    
    //Adds in the cost for volatile mind
    if (nVolatile > 0) nPPCost += nVolatile;
    
    // If PP Cost is greater than Manifester level
    if (GetManifesterLevel(oCaster) >= nPPCost)
    {
    	//If Manifest does not have enough points, cancel power
    	if (nPPCost > nPP) 
    	{
    		FloatingTextStringOnCreature("You do not have enough Power Points to manifest this power", oCaster, FALSE);
    		nCanManifest = FALSE;
    	}
    	else //Manifester has enough points, so subtract cost and manifest power
    	{
    		nPP = nPP - nPPCost;
    		FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nPP), oCaster, FALSE);
    		SetLocalInt(oCaster, "PowerPoints", nPP);
    	}
    }
    else
    {
    	FloatingTextStringOnCreature("Your manifester level is not high enough to spend that many Power Points", oCaster, FALSE);
    	nCanManifest = FALSE;
    }	
    return nCanManifest;

}


void PsychicEnervation(object oCaster, int nWildSurge)
{
	int nDice = d20(1);

	if (nWildSurge >= nDice)
	{
		int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oCaster);
		int nPP = GetLocalInt(oCaster, "PowerPoints");
	
		effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
		effect eDaze = EffectDazed();
		effect eLink = EffectLinkEffects(eMind, eDaze);
		eLink = ExtraordinaryEffect(eLink);
	
		FloatingTextStringOnCreature("You have become psychically enervated and lost power points", oCaster, FALSE);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, TurnsToSeconds(1));
		
    		nPP = nPP - nWilder;
    		FloatingTextStringOnCreature("Power Points Remaining: " + IntToString(nPP), oCaster, FALSE);
    		SetLocalInt(oCaster, "PowerPoints", nPP);	
	}
	else
	{
		int nEuphoria = 1;
		if (GetLevelByClass(CLASS_TYPE_WILDER, oCaster) > 19) nEuphoria = 3;
		else if (GetLevelByClass(CLASS_TYPE_WILDER, oCaster) > 11) nEuphoria = 2;
		
		effect eBonAttack = EffectAttackIncrease(nEuphoria);
		effect eBonDam = EffectDamageIncrease(nEuphoria, DAMAGE_TYPE_MAGICAL);
		effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
		effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nEuphoria, SAVING_THROW_TYPE_SPELL);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		effect eDur2 = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
		effect eLink = EffectLinkEffects(eSave, eDur);
		eLink = EffectLinkEffects(eLink, eDur2);
		eLink = EffectLinkEffects(eLink, eBonDam);
		eLink = EffectLinkEffects(eLink, eBonAttack);
		eLink = ExtraordinaryEffect(eLink);
		FloatingTextStringOnCreature("Surging Euphoria: " + IntToString(nWildSurge), oCaster, FALSE);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nWildSurge));
	}
}

int GetIsTelepathyPower()
{
	int nSpell = GetSpellId();
	if (nSpell == 2371 || nSpell == 2373 || nSpell == 2374)
	{
		return TRUE;
	}
	
	return FALSE;
}

int VolatileMind(object oTarget, object oCaster)
{
	int nWilder = GetLevelByClass(CLASS_TYPE_WILDER, oTarget);
	int nTelepathy = GetIsTelepathyPower();
	int nCost = 0;
	
	if (nWilder > 4 && nTelepathy == TRUE)
	{
		if (GetIsEnemy(oTarget, oCaster))
		{
			if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_4, oTarget)) nCost = 4;
			else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_3, oTarget)) nCost = 3;
			else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_2, oTarget)) nCost = 2;
			else if (GetHasFeat(FEAT_WILDER_VOLATILE_MIND_1, oTarget)) nCost = 1;
		}
	}
	
	FloatingTextStringOnCreature("Volatile Mind Cost: " + IntToString(nCost), oTarget, FALSE);
	return nCost;
}