#include "prc_inc_clsfunc"
void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    itemproperty ip = ItemPropertySkillBonus(SKILL_DISCIPLINE, 4);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyExtraMeleeDamageType(IP_CONST_DAMAGETYPE_SLASHING);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    ip = ItemPropertyLimitUseByClass(IP_CONST_CLASS_FIGHTER);
    AddItemProperty(DURATION_TYPE_PERMANENT, ip, oWeapon);
    WeaponUpgradeVisual();
}


