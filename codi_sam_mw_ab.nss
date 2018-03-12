/*
    Increase masterwork weapons to give attack bonus + 2.
*/
#include "prc_inc_clsfunc"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    itemproperty ip;
    if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_ATTACK_BONUS))
    {
        int iValue;
        ip = GetFirstItemProperty(oWeapon);
        int iBreak = FALSE;
        while (GetIsItemPropertyValid(ip) && !iBreak)
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS)
            {
                iValue = GetItemPropertyCostTableValue(ip);
                RemoveItemProperty(oWeapon, ip);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(iValue + 2), oWeapon);
                iBreak = TRUE;
            }
            ip = GetNextItemProperty(oWeapon);
        }
    }
    else
    {
        ip = ItemPropertyAttackBonus(2);
        AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    }
    WeaponUpgradeVisual();
}



