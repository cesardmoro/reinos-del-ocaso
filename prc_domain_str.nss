//::///////////////////////////////////////////////
//:: Strength Domain Power
//:: prc_domain_str.nss
//::///////////////////////////////////////////////
/*
    Grants Char level to Strength for 1 round
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

//#include "prc_inc_domain"
#include "prc_feat_const"
#include "prc_alterations"

void main()
{
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_STRENGTH_DOMAIN_POWER);

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        int nStrBeforeBonuses = GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH);
        int nConBeforeBonuses = GetAbilityScore(OBJECT_SELF, ABILITY_CONSTITUTION);
    // Variables effected by MCoK levels
    int nDur = 1;
    int nBoost = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);

    // Mighty Contender class abilities
/*    if (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oPC) > 0)
    {
        int nFeatPower = 0;
        nBoost += GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oPC);
        // At 3rd level of MCoK, the duration increases
        if (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oPC) >= 3) nDur = d4() + 1;
        // At 7th level of MCoK, add 1.5 * combined cleric + MCoK levels to strength for the first round
        // At level 10 the boost is for the entire time so you don't need this to run
        if (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oPC) >= 7 && GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oPC) < 10)
        {
            nFeatPower = FloatToInt(nBoost * 1.5);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(ABILITY_STRENGTH, nFeatPower), oTarget, 6.0);
        }
        if (GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oPC) >= 10) nBoost = FloatToInt(nBoost * 1.5);
    }*/

        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nBoost);
        effect eLink = EffectLinkEffects(eStr, eDur);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur));

        //DelayCommand(0.1, GiveExtraRageBonuses(nDur, nStrBeforeBonuses, nConBeforeBonuses, nBoost, 0, 0, DAMAGE_TYPE_BLUDGEONING, OBJECT_SELF));
}

