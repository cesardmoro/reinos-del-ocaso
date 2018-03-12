#include "nw_i0_spells"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_inc_clsfunc"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    int iStr = FALSE;
    int iDex = FALSE;
    int iCon = FALSE;
    itemproperty ip;
    int iValue;
    ip = GetFirstItemProperty(oWeapon);
    while (GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ABILITY_BONUS && GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
        {
            if(GetItemPropertySubType(ip) == ABILITY_STRENGTH && !iStr)
            {
                iValue = GetItemPropertyCostTableValue(ip);
                RemoveItemProperty(oWeapon, ip);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(ABILITY_STRENGTH, iValue + 3), oWeapon);
                iStr = TRUE;
            }
            if(GetItemPropertySubType(ip) == ABILITY_DEXTERITY && !iDex)
            {
                iValue = GetItemPropertyCostTableValue(ip);
                RemoveItemProperty(oWeapon, ip);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(ABILITY_DEXTERITY, iValue + 1), oWeapon);
                iDex = TRUE;
            }
            if(GetItemPropertySubType(ip) == ABILITY_CONSTITUTION && !iCon)
            {
                iValue = GetItemPropertyCostTableValue(ip);
                RemoveItemProperty(oWeapon, ip);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(ABILITY_CONSTITUTION, iValue + 1), oWeapon);
                iCon = TRUE;
            }
        }
        ip = GetNextItemProperty(oWeapon);
    }
    if(!iStr)
    {
        ip = ItemPropertyAbilityBonus(ABILITY_STRENGTH, 2);
        AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    }
    if(!iDex)
    {
        ip = ItemPropertyAbilityBonus(ABILITY_DEXTERITY, 1);
        AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    }
    if(!iCon)
    {
        ip = ItemPropertyAbilityBonus(ABILITY_CONSTITUTION, 1);
        AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    }
    ip = ItemPropertyDecreaseAbility(IP_CONST_ABILITY_INT, 1);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyDecreaseAbility(IP_CONST_ABILITY_WIS, 1);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyDecreaseAbility(IP_CONST_ABILITY_CHA, 1);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyLimitUseByClass(IP_CONST_CLASS_BARBARIAN);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    WeaponUpgradeVisual();
}

