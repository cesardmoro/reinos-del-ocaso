/*
    Increase masterwork weapons enhancement bonus by +1
*/
#include "prc_inc_clsfunc"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    itemproperty ip;
    if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_ENHANCEMENT_BONUS))
    {
        int iValue;
        ip = GetFirstItemProperty(oWeapon);
        int iCount;
        int iBreak = FALSE;
        while (GetIsItemPropertyValid(ip) && !iBreak)
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
            {
                iValue = GetItemPropertyCostTableValue(ip);
                RemoveItemProperty(oWeapon, ip);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(iValue + 1), oWeapon);
                iBreak = TRUE;
            }
            iCount += 1;
            ip = GetNextItemProperty(oWeapon);
        }
    }
    else
    {
        ip = ItemPropertyEnhancementBonus(1);
        AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    }
    WeaponUpgradeVisual();
}
