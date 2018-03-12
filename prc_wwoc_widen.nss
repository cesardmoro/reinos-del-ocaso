// Written by Stratovarius
// Activates the Widen Spell ability of the War Wizard of Cormyr
// This is read in the PRC AoE function in prc_inc_spells, where it increases the area.

#include "prc_feat_const"

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetLocalInt(oPC, "WarWizardOfCormyr_Widen"))
     {    
	SetLocalInt(oPC, "WarWizardOfCormyr_Widen", TRUE);
     	nMes = "*Widen Spell Activated*";
     }
     else     
     {
	// Removes effects and gives you back the uses per day
	DeleteLocalInt(oPC, "WarWizardOfCormyr_Widen");
	nMes = "*Widen Spell Deactivated*";
	IncrementRemainingFeatUses(oPC, FEAT_WWOC_WIDEN_SPELL);
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}