int StartingConditional()
{
    int bReturn = TRUE;
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    if (oWeapon == OBJECT_INVALID)
    {
        return FALSE;
    }
    if(GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_ENHANCEMENT_BONUS))
    {
        itemproperty ip = GetFirstItemProperty(oWeapon);
        while(GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
            {
                if (GetItemPropertyCostTableValue(ip) >= 10)
                {
                    bReturn = FALSE;
                }
            }
            ip = GetNextItemProperty(oWeapon);
        }
    }
    return bReturn;
}
