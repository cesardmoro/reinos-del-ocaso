//::///////////////////////////////////////////////
//:: Shining Blade of Heironeous - Brilliant Weapon
//:: prc_sbheir_holy.nss
//:://////////////////////////////////////////////
//:: Applies a temporary 1d6 Electric Bonus and a
//:: 2d6 Bonus vs evil creatures to the
//:: Shining Blade's weapon. Duration based on Cha
//:: and Class level. Also adds +20 to Attack.
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
    int iCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    if (iCha < 0) iCha = 0;
    int iDur = (GetLevelByClass(CLASS_TYPE_SHINING_BLADE,oPC)) + iCha;

	if (GetLocalInt(oPC, "SBWeap") == TRUE) return;

	    if (GetBaseItemType(oWeapon) == BASE_ITEM_LONGSWORD)
	    {
	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, DAMAGE_BONUS_1d6), oWeapon, RoundsToSeconds(iDur));
	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_DIVINE, DAMAGE_BONUS_2d6), oWeapon, RoundsToSeconds(iDur));
	    //AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(20), oWeapon, RoundsToSeconds(iDur));
	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectAttackIncrease(20)), oPC, RoundsToSeconds(iDur));
	    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_WHITE), oWeapon, RoundsToSeconds(iDur));
	    SetLocalInt(oPC, "SBWeap", TRUE);
	    DelayCommand(RoundsToSeconds(iDur), DeleteLocalInt(oPC, "SBWeap"));
	    }
}
