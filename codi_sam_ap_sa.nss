#include "prc_inc_clsfunc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    int bReturn = TRUE;
    if(GetLevelByClass(CLASS_TYPE_ROGUE,oPC) < 1)
    {
        bReturn = FALSE;
    }
    if(GetPropertyValue(oWeapon, ITEM_PROPERTY_USE_LIMITATION_CLASS, IP_CONST_CLASS_ROGUE) != -1)
    {
        bReturn = FALSE;
    }
    return bReturn;
}
