#include "prc_inc_clsfunc"
#include "nw_i0_spells"
#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    itemproperty ip = ItemPropertySkillBonus(SKILL_HIDE, 4);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);

    ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_VORPAL, IP_CONST_ONHIT_SAVEDC_18);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);

    ip = ItemPropertyLimitUseByClass(IP_CONST_CLASS_ROGUE);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);

    WeaponUpgradeVisual();
}

