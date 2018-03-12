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
    itemproperty ip;

    ip = ItemPropertyDamageBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_1d6);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyACBonusVsRace(IP_CONST_RACIALTYPE_UNDEAD, 4);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyLimitUseByClass(IP_CONST_CLASS_CLERIC);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyLimitUseByClass(IP_CONST_CLASS_PALADIN);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    WeaponUpgradeVisual();
}

