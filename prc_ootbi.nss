//::///////////////////////////////////////////////
//:: Order of the Bow Initiate
//:: prc_ootbi.nss
//:://////////////////////////////////////////////
//:: Applies Order of the Bow Initiate Bonuses
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 20, 2004
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"

void RemoveGreaterWeaponFocus(object oPC, object oWeap)
{
    if (DEBUG) FloatingTextStringOnCreature("Remove GreaterWeaponFocus is run", oPC);

    RemoveEffectsFromSpell(oPC, SPELL_OOTBI_GREATER_WEAPON_FOCUS);
    DeleteLocalInt(oWeap, "GreaterWeaponFocus");
}

void GreaterWeaponFocus(object oPC, object oWeap)
{
    if(GetLocalInt(oWeap, "GreaterWeaponFocus") == TRUE) return;

    if (DEBUG) FloatingTextStringOnCreature("Add GreaterWeaponFocus is run", oPC);

    RemoveGreaterWeaponFocus(oPC, oWeap);
    // Greater Weapon Focus ability
    DelayCommand(0.1, ActionCastSpellOnSelf(SPELL_OOTBI_GREATER_WEAPON_FOCUS));
    SetLocalInt(oWeap, "GreaterWeaponFocus", TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oUnequip = GetItemLastUnequipped();
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    if(GetLevelByClass(CLASS_TYPE_ORDER_BOW_INITIATE, oPC) >= 4)
    {
       	if (iEquip == 1)    RemoveGreaterWeaponFocus(oPC, oUnequip);
        if (iEquip == 2)
        {
        	if (GetBaseItemType(oWeap) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeap) == BASE_ITEM_SHORTBOW)
        	{
        		GreaterWeaponFocus(oPC, oWeap);
        	}
        }
    }        
}