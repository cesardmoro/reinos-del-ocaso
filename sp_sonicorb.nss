#include "spinc_common"
#include "spinc_orb"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eVisFail = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eFailSave = EffectDeaf();

    DoOrb(eVis, EffectLinkEffects(eVisFail, eFailSave),
        SPGetElementalSavingThrowType(SAVING_THROW_TYPE_SONIC), SPGetElementalDamageType(DAMAGE_TYPE_SONIC));
}
