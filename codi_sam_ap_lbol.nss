#include "prc_inc_clsfunc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");

    return (GetPropertyValue(oWeapon, ITEM_PROPERTY_CAST_SPELL, IP_CONST_CASTSPELL_LIGHTNING_BOLT_10) == -1);
}

