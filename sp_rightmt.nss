#include "spinc_common"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    // Get the target and raise the spell cast event.
    object oTarget = GetSpellTargetObject();
    SPRaiseSpellCastAt(oTarget, FALSE);

    // Determine the spell's duration, taking metamagic feats into account.
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nCasterLvl));

    // Calculate the proper DR.
    int nDR = 5;
    if (nCasterLvl >= 12) nDR = 10;
    if (nCasterLvl >= 15) nDR = 15;

    // Create the chain of buffs to apply, including the vfx.
    effect eBuff = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
   // eBuff = EffectLinkEffects (eBuff, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
    eBuff = EffectLinkEffects (eBuff, EffectACDecrease(1, AC_NATURAL_BONUS));
   // eBuff = EffectLinkEffects (eBuff, EffectDamageReduction(nDR, DAMAGE_POWER_PLUS_ONE));
    eBuff = EffectLinkEffects (eBuff, EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR));

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3), oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLvl);
//  SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_RESTORATION_GREATER), oTarget);

    SPSetSchool();
}
