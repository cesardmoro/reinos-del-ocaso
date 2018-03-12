#include "prc_inc_clsfunc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");

    return (GetPropertyValue(oWeapon, ITEM_PROPERTY_MASSIVE_CRITICALS) == -1);
}

