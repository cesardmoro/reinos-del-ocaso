#include "prc_inc_clsfunc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");

    return !(GetPropertyValue(oWeapon, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_COLD) == IP_CONST_DAMAGEBONUS_2d12);
}

