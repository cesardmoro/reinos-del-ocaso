#include "nw_i0_spells"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_inc_clsfunc"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    int iLevel = GetLevelByClass(CLASS_TYPE_SAMURAI, oPC);
    itemproperty ip = ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_2d8);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    WeaponUpgradeVisual();
}

