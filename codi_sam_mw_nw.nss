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
    ip = ItemPropertySkillBonus(SKILL_ANIMAL_EMPATHY, 4);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    int iSamur = GetLevelByClass(CLASS_TYPE_SAMURAI, oPC);
    if(iSamur < 10)
    {
        iSamur = 10;
    }
    ip = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_CALL_LIGHTNING, iSamur);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyLimitUseByClass(IP_CONST_CLASS_DRUID);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyLimitUseByClass(IP_CONST_CLASS_RANGER);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    WeaponUpgradeVisual();
}
