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
    int iSamur = GetLevelByClass(CLASS_TYPE_SAMURAI, oPC);
    if(iSamur < 10)
    {
        iSamur = 10;
    }
    itemproperty ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_SOUND_BURST, iSamur);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_SONIC, 15);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyLimitUseByClass(IP_CONST_CLASS_BARD);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    WeaponUpgradeVisual();
}

