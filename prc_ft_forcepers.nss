//::///////////////////////////////////////////////
//:: Force of Personality
//:: prc_ft_forcepers.nss
//:://////////////////////////////////////////////
/*
    Replaces Wisdom mod with Cha mod on will saves.
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 16 August 2005
//:: Modified By: Flaming_Sword
//:: Modified On: 21 November 2005
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = GetSpellTargetObject();
    int nWis = GetAbilityModifier(ABILITY_WISDOM, oPC);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    int nMod = nCha - nWis;

    if(nMod > 0)    //as spell effect, easily removed
    {
        effect eIncrease = EffectSavingThrowIncrease(SAVING_THROW_WILL, nMod);
        eIncrease = SupernaturalEffect(eIncrease);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIncrease, oPC);
    }
    else if(nMod < 0)
    {
        effect eDecrease = EffectSavingThrowDecrease(SAVING_THROW_WILL, nMod * -1);
        eDecrease = SupernaturalEffect(eDecrease);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDecrease, oPC);
    }

    /*  //old code, just in case
    // If the stats are the same, do nothing
    if(GetLocalInt(oPC, "ForceOfPersonalityWis") == nWis && GetLocalInt(oPC, "ForceOfPersonalityCha") == nCha) return;

    SetLocalInt(oPC, "ForceOfPersonalityWis", nWis);
    SetLocalInt(oPC, "ForceOfPersonalityCha", nCha);

    // If wisdom is larger, we need to reduce the will bonus
    if (nWis > nCha)
    {
        // Amount to reduce by
        nMod = nWis - nCha;
        effect eDecrease = EffectSavingThrowDecrease(SAVING_THROW_WILL, nMod);
        eDecrease = ExtraordinaryEffect(eDecrease);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDecrease, oPC);
    }
    // Does not check if Wis is equal to Cha, since in that case you do nothing
    // Apply a bonus if Cha is higher than Wis
    if (nCha > nWis)
    {
        // Amount to increase by
        nMod = nCha - nWis;
        effect eIncrease = EffectSavingThrowIncrease(SAVING_THROW_WILL, nMod);
        eIncrease = ExtraordinaryEffect(eIncrease);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eIncrease, oPC);
    }
    */
}