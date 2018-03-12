/*
    Increase masterwork weapons will save.
*/
#include "prc_inc_clsfunc"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    itemproperty ip;
    if (TRUE)
    {
        int iValue;
        ip = GetFirstItemProperty(oWeapon);
        int iBreak = FALSE;
        while (GetIsItemPropertyValid(ip) && !iBreak)
        {
            if(GetItemPropertyType(ip) == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC && GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
            {
                //SpeakString("Ability Strength: " + IntToString(ABILITY_CONSTITUTION));
                //SpeakString("Cost Table: " + IntToString(GetItemPropertyCostTable(ip)));
                //SpeakString("Cost Table Value: " + IntToString(GetItemPropertyCostTableValue(ip)));
                //SpeakString("Param1: " + IntToString(GetItemPropertyParam1(ip)));
                //SpeakString("Param1Value: " + IntToString(GetItemPropertyParam1Value(ip)));
                //SpeakString("SubType: " + IntToString(GetItemPropertySubType(ip)));
                if(GetItemPropertySubType(ip) == SAVING_THROW_WILL)
                {
                    iValue = GetItemPropertyCostTableValue(ip);
                    RemoveItemProperty(oWeapon, ip);
                    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(SAVING_THROW_WILL, iValue + 2), oWeapon);
                    iBreak = TRUE;
                }
            }
            ip = GetNextItemProperty(oWeapon);
        }
        if(!iBreak)
        {
            ip = ItemPropertyBonusSavingThrow(SAVING_THROW_WILL, 2);
            AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
        }
    }
    WeaponUpgradeVisual();
}


