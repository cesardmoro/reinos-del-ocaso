#include "prc_inc_clsfunc"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    itemproperty ip = ItemPropertyKeen();
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    WeaponUpgradeVisual();
}

