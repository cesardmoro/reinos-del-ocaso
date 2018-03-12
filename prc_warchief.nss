//::///////////////////////////////////////////////
//:: War Chief
//:: prc_warchief.nss
//:://////////////////////////////////////////////
//:: Applies the Warchief Charisma boost
//:://////////////////////////////////////////////

#include "prc_alterations"

// * Applies the Warchief's stat bonuses as CompositeBonuses on object's skin.
void WarchiefBonus(object oPC, object oSkin, int iLevel)
{
    string sFlag = "WarchiefCha";

    if(GetLocalInt(oSkin, sFlag) == iLevel) return;

    if(iLevel > 0)
    {
        SetCompositeBonus(oSkin, sFlag, iLevel, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
    }
}

void ApplyDevotedBodyguard(object oPC, object oArmor)
{
     IPSafeAddItemProperty(oArmor, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1), 9999.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void RemoveDevotedBodyguard(object oPC, object oArmor)
{
     RemoveSpecificProperty(oArmor, ITEM_PROPERTY_ONHITCASTSPELL, IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 0, 1, "", 1, DURATION_TYPE_TEMPORARY);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nWarChief = GetLevelByClass(CLASS_TYPE_WARCHIEF, oPC);
    int nBonus = 0;
    object oItem;
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    if (nWarChief >= 10) nBonus = 6;
    else if (nWarChief >= 6) nBonus = 4;
    else if (nWarChief >= 2) nBonus = 2;

    // Get the first boost at level 2
    if (nWarChief > 1) WarchiefBonus(oPC, oSkin, nBonus);
    if (nWarChief >= 8)
    {
        if(iEquip == 2)       // On Equip
        {
             // add bonus to armor
             oItem = GetItemLastEquipped();

             if(oItem == oArmor)
             {
                  ApplyDevotedBodyguard(oPC, oItem);
             }
        }
        else if(iEquip == 1)  // Unequip
        {
             oItem = GetItemLastUnequipped();

             if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
             {
                  RemoveDevotedBodyguard(oPC, oItem);
             }
        }
        else                  // On level, rest, or other events
        {
             RemoveDevotedBodyguard(oPC, oArmor);
             ApplyDevotedBodyguard(oPC, oArmor);
        }
    }

}
