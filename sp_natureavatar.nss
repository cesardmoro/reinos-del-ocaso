#include "spinc_common"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;



    SPSetSchool(SPELL_SCHOOL_EVOCATION);
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    // Declare major variables
    object oTarget = GetSpellTargetObject();

    if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget)
    {
      // Signal the spell cast at event
      SPRaiseSpellCastAt(oTarget, FALSE);

      int nCasterLevel = PRCGetCasterLevel();

      effect eff = EffectAttackIncrease(10);
      eff = EffectLinkEffects(eff,EffectDamageIncrease(DAMAGE_BONUS_10,DAMAGE_TYPE_SLASHING));
      eff = EffectLinkEffects(eff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
      eff = EffectLinkEffects(eff, EffectHaste());

      int HP = SPGetMetaMagicDamage(-1, nCasterLevel, 8);

      // Get duration, 1 minute / level unless extended.
      float fDuration = SPGetMetaMagicDuration(TurnsToSeconds(nCasterLevel));

      // Build the list of fancy visual effects to apply when the spell goes off.
      effect eVFX = EffectVisualEffect(VFX_IMP_HOLY_AID);

      // Remove existing effect, if any.
      RemoveEffectsFromSpell(oTarget, GetSpellId());

      // Apply effects and VFX to target
      SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(HP), oTarget, fDuration,TRUE,-1,nCasterLvl);
      SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eff, oTarget, fDuration,TRUE,-1,nCasterLvl);
      SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, oTarget);
    }
    SPSetSchool();
}
