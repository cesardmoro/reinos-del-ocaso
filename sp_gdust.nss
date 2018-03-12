#include "spinc_common"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    // Apply a burst visual effect at the target location.
    location lTarget = GetSpellTargetLocation();
    effect eImpact = EffectVisualEffect(783);
   // ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eImpact, lTarget);

    // Apply the AOE (vfx only) object to the specified location
   // effect eAOE = EffectAreaOfEffect(783, "****", "****", "****");


  int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    // Determine the spell's duration.
    float fDuration = SPGetMetaMagicDuration(RoundsToSeconds(nCasterLvl));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eImpact, lTarget, fDuration);
    effect eBlindness = EffectLinkEffects(EffectBlindness(),
        EffectVisualEffect(VFX_DUR_BLIND));
    effect eHidePenalty = EffectLinkEffects(EffectSkillDecrease(SKILL_HIDE, 40),
        EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SPRaiseSpellCastAt(oTarget);

            // Apply impact vfx.
            SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                EffectVisualEffect(VFX_IMP_REMOVE_CONDITION), oTarget);

            // Creatures take the hide penalty whether they save or not.
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHidePenalty, oTarget, fDuration,TRUE,-1,nCasterLvl
);

            // Creatures that are invisible become visible whether they save or not.  We do
            // this by looping through all the creature's effects looking for invisibility
            // effects and removing them.
            effect eTarget = GetFirstEffect(oTarget);
            while (GetIsEffectValid(eTarget))
            {
                int nType = GetEffectType(eTarget);
                if (EFFECT_TYPE_INVISIBILITY == nType || EFFECT_TYPE_IMPROVEDINVISIBILITY == nType)
                    RemoveEffect (oTarget, eTarget);

                eTarget = GetNextEffect(oTarget);
            }

            // Let the creature make a will save, if it fails it's blinded.
            if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, SPGetSpellSaveDC(oTarget,OBJECT_SELF)))
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlindness, oTarget, fDuration,TRUE,-1,nCasterLvl
);
        }

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
    }

    SPSetSchool();
}
