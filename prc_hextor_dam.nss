#include "prc_spell_const"
#include "nw_i0_spells"
#include "inc_item_props"

int ConvertDamage(int iVal)
{
    int iConv = 0;
    switch (iVal)
    {
        case 1:  iConv = DAMAGE_BONUS_1;  break;
        case 2:  iConv = DAMAGE_BONUS_2;  break;
        case 3:  iConv = DAMAGE_BONUS_3;  break;
        case 4:  iConv = DAMAGE_BONUS_4;  break;
        case 5:  iConv = DAMAGE_BONUS_5;  break;
        case 6:  iConv = DAMAGE_BONUS_6;  break;
        case 7:  iConv = DAMAGE_BONUS_7;  break;
        case 8:  iConv = DAMAGE_BONUS_8;  break;
        case 9:  iConv = DAMAGE_BONUS_9;  break;
        case 10: iConv = DAMAGE_BONUS_10; break;
        case 11: iConv = DAMAGE_BONUS_11; break;
        case 12: iConv = DAMAGE_BONUS_12; break;
    }
    
    return iConv;
}

void main()
{
    object oPC = GetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iDamageType = (!GetIsObjectValid(oWeap)) ? DAMAGE_TYPE_BLUDGEONING : GetItemDamageType(oWeap);
    
    RemoveEffectsFromSpell(oPC, GetSpellId());
    
    effect eDam = EffectDamageIncrease(ConvertDamage(GetLocalInt(oPC, "HexBSDam")), iDamageType);
    eDam = ExtraordinaryEffect(eDam);
    
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oPC);
}
