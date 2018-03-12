//::///////////////////////////////////////////////
//:: Shining Blade of Heironeous - Shock Weapon
//:: prc_sbheir_shock.nss
//:://////////////////////////////////////////////
//:: Applies a temporary 1d6 Electric Bonus to the
//:: Shining Blade's weapon. Duration based on Cha
//:: and Class level.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 13, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_class_const"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iDur = (GetLevelByClass(CLASS_TYPE_SHINING_BLADE,oPC) + GetAbilityModifier(ABILITY_CHARISMA));

	if (GetLocalInt(oPC, "SBWeap") == TRUE) return;

	    if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGSWORD)
	    {
	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, DAMAGE_BONUS_1d6), oWeapon, RoundsToSeconds(iDur));
	    SetLocalInt(oPC, "SBWeap", TRUE);
	    DelayCommand(RoundsToSeconds(iDur), DeleteLocalInt(oPC, "SBWeap"));
	    }
}
