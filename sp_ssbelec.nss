#include "spinc_common"
#include "spinc_bolt"
#include "spinc_serpsigh"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    // Get the number of damage dice.
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDice = nCasterLevel > 10 ? 10 : nCasterLevel;

    DoBolt (nCasterLevel,6, 0, nDice, VFX_BEAM_LIGHTNING, VFX_IMP_LIGHTNING_S,
        SPGetElementalDamageType(DAMAGE_TYPE_ELECTRICAL), SPGetElementalSavingThrowType(SAVING_THROW_TYPE_ELECTRICITY),
        SPELL_SCHOOL_EVOCATION, FALSE, SPELL_SERPENTS_SIGH);

    DamageSelf (10, VFX_IMP_LIGHTNING_S);
}

