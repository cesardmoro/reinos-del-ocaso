//::///////////////////////////////////////////////
//:: Tactile Trapsmith
//:: prc_ft_tacttrap.nss
//:://////////////////////////////////////////////
/*
    Replaces Int mod with Dex mod on Search and Disable Trap checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 16 August 2005
//:: Modified By: Flaming_Sword
//:: Modified On: 18 November 2005
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int nMod = nDex - nInt;

    if(nMod > 0)
    {
        SetCompositeBonus(oSkin, "TactileTrapsmithSearchIncrease", nMod,
            ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        SetCompositeBonus(oSkin, "TactileTrapsmithDisableIncrease", nMod,
            ITEM_PROPERTY_SKILL_BONUS, SKILL_DISABLE_TRAP);
        SetCompositeBonus(oSkin, "TactileTrapsmithSearchDecrease", 0,
            ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_SEARCH);
        SetCompositeBonus(oSkin, "TactileTrapsmithDisableDecrease", 0,
            ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_DISABLE_TRAP);
    }
    else if(nMod < 0)
    {
        SetCompositeBonus(oSkin, "TactileTrapsmithSearchDecrease", nMod * -1,
            ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_SEARCH);
        SetCompositeBonus(oSkin, "TactileTrapsmithDisableDecrease", nMod * -1,
            ITEM_PROPERTY_DECREASED_SKILL_MODIFIER, SKILL_DISABLE_TRAP);
        SetCompositeBonus(oSkin, "TactileTrapsmithSearchIncrease", 0,
            ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
        SetCompositeBonus(oSkin, "TactileTrapsmithDisableIncrease", 0,
            ITEM_PROPERTY_SKILL_BONUS, SKILL_DISABLE_TRAP);
    }
    /*  //old code, just in case
    object oPC = OBJECT_SELF;
    int nInt = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
    int nDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int nMod;

    // If Int is larger, we need to reduce the bonus
    if (nInt > nDex)
    {
        // Amount to reduce by
        nMod = nInt - nDex;
        effect eSearch = EffectSkillDecrease(SKILL_SEARCH, nMod);
        effect eTrap = EffectSkillDecrease(SKILL_DISABLE_TRAP, nMod);
        effect eDecrease = EffectLinkEffects(eSearch, eTrap);
        eDecrease = ExtraordinaryEffect(eDecrease);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDecrease, oPC);
    }
    // Does not check if Dex is equal to Int, since in that case you do nothing
    // Apply a bonus if Dex is higher than Int
    if (nDex > nInt)
    {
        // Amount to increase by
        nMod = nDex - nInt;
        effect eSearch = EffectSkillIncrease(SKILL_SEARCH, nMod);
        effect eTrap = EffectSkillIncrease(SKILL_DISABLE_TRAP, nMod);
        effect eIncrease = EffectLinkEffects(eSearch, eTrap);
        eIncrease = ExtraordinaryEffect(eIncrease);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIncrease, oPC);
    }
    */
}