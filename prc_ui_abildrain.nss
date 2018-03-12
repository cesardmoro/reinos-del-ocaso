//::///////////////////////////////////////////////
//:: Name        Immunity: Ability/Level drain
//:: FileName    prc_ui_abildrain.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/* 

*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 12/09/05
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
	//define vars
	object oSkin = GetPCSkin(OBJECT_SELF);
	itemproperty iProp = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN);
	
	//apply item property 
	IPSafeAddItemProperty(oSkin, iProp, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}


