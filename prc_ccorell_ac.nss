//////////////////////
// Champion of Corellon Larethian
// Superior Defense
//
// Script by LittleDragon
//
// Adds a bonus tu AC based on dexterity and limited by the maximum dexterity
// bonus of the armor and the feat Superior Defense
///////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

void main()
{
    object oPC = GetSpellTargetObject();

    int iSuperiorDefense =  (GetHasFeat(SUPERIOR_DEFENSE_1, oPC)) ? 1 :
                            (GetHasFeat(SUPERIOR_DEFENSE_2, oPC)) ? 2 :
                            (GetHasFeat(SUPERIOR_DEFENSE_3, oPC)) ? 3 :
                            0;
    if (iSuperiorDefense==0)
        return;

    int dexterityBonus = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    int armorMaxAcBonus;
    switch (GetBaseAC(oArmor)) {
        case 4:         armorMaxAcBonus = 4; break;
        case 5:         armorMaxAcBonus = 3; break;
        case 6:         armorMaxAcBonus = 2; break;
        case 7:         armorMaxAcBonus = 1; break;
        case 8:         armorMaxAcBonus = 2; break;
        default:        armorMaxAcBonus = 0; break;
    }

    if (armorMaxAcBonus > 0 && dexterityBonus > armorMaxAcBonus)
    {
        int dodgeBonus = dexterityBonus - armorMaxAcBonus;
        dodgeBonus = (dodgeBonus > iSuperiorDefense) ? iSuperiorDefense : dodgeBonus;

        effect eAcBonus = EffectACIncrease(dodgeBonus);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eAcBonus), oPC);
    }
}
