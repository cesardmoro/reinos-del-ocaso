////////////////////
// Champion of Corellon Larethian
// Corellon's Wrath
//
// Script by LittleDragon
//
// The CoCL gains a +2 sacred bonus on attack rolls and deals an extra 2d6 points of damage

#include "rdo_const_feat"
#include "x2_inc_itemprop"

void main()
{
    object oChampion = OBJECT_SELF;
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oChampion);

    if (!GetIsObjectValid(oWeapon) || !IPGetIsMeleeWeapon(oWeapon))
    {
        FloatingTextStringOnCreature("Debes tener equipada un arma cuerpo a cuerpo", oChampion, FALSE);
    }
    else
    {
        int weaponAttackBonus;
        itemproperty ipIterada = GetFirstItemProperty(oWeapon);
        while (GetIsItemPropertyValid(ipIterada))
        {
            if (GetItemPropertyType(ipIterada)==ITEM_PROPERTY_ATTACK_BONUS)
            {
                int temp = GetItemPropertyCostTableValue(ipIterada);
                if (temp > weaponAttackBonus) weaponAttackBonus = temp;
            }
            ipIterada = GetNextItemProperty(oWeapon);
        }
        weaponAttackBonus += 2;

        itemproperty ipAttackBonus = ItemPropertyAttackBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, weaponAttackBonus);
        itemproperty ipDamageBonus = ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6);
        itemproperty ipHolyVisual  = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
        effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eVis, eDur);

        int nDuration = 3 + GetAbilityModifier(ABILITY_CHARISMA, oChampion);
        if (nDuration < 1) nDuration = 1;
        float fDuration = RoundsToSeconds(nDuration);

        IPSafeAddItemProperty(oWeapon, ipAttackBonus, fDuration);
        IPSafeAddItemProperty(oWeapon, ipDamageBonus, fDuration);
        IPSafeAddItemProperty(oWeapon, ipHolyVisual, fDuration);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oChampion, fDuration);
    }
}
