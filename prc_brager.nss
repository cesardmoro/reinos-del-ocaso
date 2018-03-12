//::///////////////////////////////////////////////
//:: Battlerager
//:: prc_brager.nss
//:://////////////////////////////////////////////
//:: Applies Ferocious Prowess Bonus
//:://////////////////////////////////////////////
//:: Created By: Lockindal
//:: Created On: July 23, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_inc_clsfunc"

void AddFerociousProwess(object oPC)
{
	if(GetHasFeat(FEAT_FEROCIOUS_PROW, oPC))
	{
                ActionCastSpellOnSelf(SPELL_BATTLERAGER_DAMAGE);   // +1 to attack and damage rolls
	}
}

void main()
{
	//Declare main variables.
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int iEquip = GetLocalInt(oPC, "ONEQUIP");
    
	AddFerociousProwess(oPC);
}
