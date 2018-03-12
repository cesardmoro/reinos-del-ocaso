#include "prc_inc_clsfunc"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    itemproperty ip = ItemPropertyHolyAvenger();
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    WeaponUpgradeVisual();
}

