#include "spinc_common"
#include "spinc_lessorb"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    DoLesserOrb(EffectVisualEffect(VFX_IMP_FROST_S), SPGetElementalDamageType(DAMAGE_TYPE_COLD));
}

