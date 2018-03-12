//::///////////////////////////////////////////////
//::Positive Energy Resistance 
//:: prc_ud_poe.nss
//:://////////////////////////////////////////////
//:: This script applies resistance of 10 against
//:: positive energy to the PC.
//:: 
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: Aug 2, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	//define variables
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
      //constuct effect
	effect ePosEnResist = EffectDamageResistance(DAMAGE_TYPE_POSITIVE, 10, 0);
      //apply effect
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePosEnResist, oSkin);
}
