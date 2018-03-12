//::///////////////////////////////////////////////
//:: Name        Immunity: Death
//:: FileName    prc_ui_death.nss
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
	itemproperty iProp = ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DEATH_MAGIC);
	
	//apply item property 
	IPSafeAddItemProperty(oSkin, iProp, 0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}

