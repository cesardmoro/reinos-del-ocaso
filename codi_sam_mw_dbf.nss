/*
    Increase masterwork weapons to give +d6 fire damage.
*/
#include "prc_inc_clsfunc"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    itemproperty ip;
    if (GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_DAMAGE_BONUS))
    {
        int iValue;
        ip = GetFirstItemProperty(oWeapon);
        int iBreak = FALSE;
        while (GetIsItemPropertyValid(ip) && !iBreak)
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS)
            {
                if(GetItemPropertySubType(ip) == IP_CONST_DAMAGETYPE_FIRE)
                {
                    iValue = GetItemPropertyCostTableValue(ip);
                    int iNew;
                    if (iValue == IP_CONST_DAMAGEBONUS_1d6)
                    {
                        iNew = IP_CONST_DAMAGEBONUS_2d6;
                    }
                    else if(iValue == IP_CONST_DAMAGEBONUS_2d6)
                    {
                        iNew = IP_CONST_DAMAGEBONUS_2d12;
                    }
                    RemoveItemProperty(oWeapon, ip);
                    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE,iNew), oWeapon);
                    iBreak = TRUE;
                }
            }
            ip = GetNextItemProperty(oWeapon);
        }
    }
    else
    {
        ip = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6);
        AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    }
    WeaponUpgradeVisual();
}

