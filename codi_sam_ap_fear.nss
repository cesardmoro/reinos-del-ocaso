#include "prc_inc_clsfunc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");

    return (GetPropertyValue(oWeapon, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_FEAR) == -1);
}

