// Written by Stratovarius
// Turns Rune Chant on and off.

#include "prc_alterations"

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";
     
     if (GetIsImmune(oPC, IMMUNITY_TYPE_SLOW))
     {
	// Removes effects
	RemoveSpellEffects(GetSpellId(), oPC, oPC);
	DeleteLocalInt(oPC, "RuneChant");
	nMes = "*Immune to Slowing - Canceling Rune Chant*";
     }
     else if(!GetHasSpellEffect(SPELL_RUNE_CHANT))
     {  
     	effect eSlow = EffectSlow();
     	eSlow = SupernaturalEffect(eSlow);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, OBJECT_SELF, HoursToSeconds(99));
    	SetLocalInt(oPC, "RuneChant", TRUE);
     	nMes = "*Rune Chant Activated*";
     }
     else     
     {
	// Removes effects
	RemoveSpellEffects(GetSpellId(), oPC, oPC);
	DeleteLocalInt(oPC, "RuneChant");
	nMes = "*Rune Chant Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}