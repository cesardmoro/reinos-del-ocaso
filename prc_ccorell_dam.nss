///////////////////////////
// Champion of Corellon's Elegant Strike
//
// Script By LittleDragon
//////////////////////////////

void main()
{
    object oPC = GetSpellTargetObject();

    int nDamageBonus;
    switch (GetAbilityModifier(ABILITY_DEXTERITY, oPC)) {
        case 1:         nDamageBonus = DAMAGE_BONUS_1; break;
        case 2:         nDamageBonus = DAMAGE_BONUS_2; break;
        case 3:         nDamageBonus = DAMAGE_BONUS_3; break;
        case 4:         nDamageBonus = DAMAGE_BONUS_4; break;
        case 5:         nDamageBonus = DAMAGE_BONUS_5; break;
        case 6:         nDamageBonus = DAMAGE_BONUS_6; break;
        case 7:         nDamageBonus = DAMAGE_BONUS_7; break;
        case 8:         nDamageBonus = DAMAGE_BONUS_8; break;
        case 9:         nDamageBonus = DAMAGE_BONUS_9; break;
        case 10:        nDamageBonus = DAMAGE_BONUS_10; break;
        case 11:        nDamageBonus = DAMAGE_BONUS_11; break;
        case 12:        nDamageBonus = DAMAGE_BONUS_12; break;
        case 13:        nDamageBonus = DAMAGE_BONUS_13; break;
        case 14:        nDamageBonus = DAMAGE_BONUS_14; break;
        case 15:        nDamageBonus = DAMAGE_BONUS_15; break;
        case 16:        nDamageBonus = DAMAGE_BONUS_16; break;
        case 17:        nDamageBonus = DAMAGE_BONUS_17; break;
        case 18:        nDamageBonus = DAMAGE_BONUS_18; break;
        case 19:        nDamageBonus = DAMAGE_BONUS_19; break;
        case 20:        nDamageBonus = DAMAGE_BONUS_20; break;
        default:        nDamageBonus = DAMAGE_BONUS_2d8; break;
    }

    int damageType = DAMAGE_TYPE_MAGICAL;
    switch (GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC))) {
        case BASE_ITEM_LONGSWORD:           damageType = DAMAGE_TYPE_SLASHING; break;
        case BASE_ITEM_SCIMITAR:            damageType = DAMAGE_TYPE_SLASHING; break;
        case BASE_ITEM_RAPIER:              damageType = DAMAGE_TYPE_PIERCING; break;
    }

    // I don't know what the values of the DAMAGE_BONUS_* are,
    // so I use DAMAGE_BONUS_2d8 to know if there's no damage bonus
    if (nDamageBonus!=DAMAGE_BONUS_2d8 && damageType != DAMAGE_TYPE_MAGICAL)
    {
        effect eDamageBonus = EffectDamageIncrease(nDamageBonus, damageType);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eDamageBonus), oPC);
    }
}
