#include "spinc_common"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    SPSetSchool(SPELL_SCHOOL_ABJURATION);

    // Declare major variables
    object oTarget = GetSpellTargetObject();

    // Signal the spell cast at event
    SPRaiseSpellCastAt(oTarget, FALSE);

    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);

    // DR 10/-.
    effect eStone = EffectDamageReduction(10, DAMAGE_POWER_ENERGY);
    eStone = EffectLinkEffects(eStone, EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));

    // Get duration, 1 round / level unless extended.
    float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nCasterLevel));

    // Build the list of fancy visual effects to apply when the spell goes off.
    effect eVFX = EffectVisualEffect(VFX_IMP_DEATH_WARD);

    // Remove existing effect, if any.
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    // Apply effects and VFX to target
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStone, oTarget, fDuration,TRUE,-1,nCasterLevel);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);

    SPSetSchool();
}
