#include "prc_spell_const"
#include "prc_feat_const"
#include "prc_alterations"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    int iDamageType = (!GetIsObjectValid(oRight)) ? DAMAGE_TYPE_BASE_WEAPON : GetItemDamageType(oRight);
    int IntToDam;

    if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==1)
    {
        IntToDam = DAMAGE_BONUS_1;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==2)
    {
        IntToDam = DAMAGE_BONUS_2;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==3)
    {
        IntToDam = DAMAGE_BONUS_3;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==4)
    {
        IntToDam = DAMAGE_BONUS_4;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==5)
    {
        IntToDam = DAMAGE_BONUS_5;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==6)
    {
        IntToDam = DAMAGE_BONUS_6;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==7)
    {
        IntToDam = DAMAGE_BONUS_7;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==8)
    {
        IntToDam = DAMAGE_BONUS_8;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==9)
    {
        IntToDam = DAMAGE_BONUS_9;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==10)
    {
        IntToDam = DAMAGE_BONUS_10;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==11)
    {
        IntToDam = DAMAGE_BONUS_11;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==12)
    {
        IntToDam = DAMAGE_BONUS_12;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==13)
    {
        IntToDam = DAMAGE_BONUS_13;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==14)
    {
        IntToDam = DAMAGE_BONUS_14;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==15)
    {
        IntToDam = DAMAGE_BONUS_15;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==16)
    {
        IntToDam = DAMAGE_BONUS_16;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==17)
    {
        IntToDam = DAMAGE_BONUS_17;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==18)
    {
        IntToDam = DAMAGE_BONUS_18;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)==19)
    {
        IntToDam = DAMAGE_BONUS_19;
    }
    else if (GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)>19)
    {
        IntToDam = DAMAGE_BONUS_20;
    }

    effect eDam = EffectDamageIncrease(IntToDam, iDamageType);

    RemoveEffectsFromSpell(oPC, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oPC);
}