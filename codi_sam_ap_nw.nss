#include "prc_inc_clsfunc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    int bReturn = TRUE;
    if(GetLevelByClass(CLASS_TYPE_DRUID,oPC) < 1 || GetLevelByClass(CLASS_TYPE_RANGER,oPC) < 1)
    {
        bReturn = FALSE;
    }
    if(GetPropertyValue(oWeapon, ITEM_PROPERTY_USE_LIMITATION_CLASS, IP_CONST_CLASS_DRUID) != -1)
    {
        bReturn = FALSE;
    }
    return bReturn;
}

