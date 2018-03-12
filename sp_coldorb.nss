#include "spinc_common"
#include "spinc_orb"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eVisFail = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eFailSave = EffectBlindness();

    DoOrb(eVis, EffectLinkEffects(eVisFail, eFailSave),
        SPGetElementalSavingThrowType(SAVING_THROW_TYPE_COLD), SPGetElementalDamageType(DAMAGE_TYPE_COLD));
}

