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
    int iSamuraiLevel = GetLevelByClass(CLASS_TYPE_SAMURAI, oPC);
    if(iSamuraiLevel < 10)
    {
        iSamuraiLevel = 10;
    }
    itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_SILENCE, iSamuraiLevel);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    WeaponUpgradeVisual();
}

