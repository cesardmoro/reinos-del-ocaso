#include "spinc_common"
#include "spinc_burst"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    // Get the number of damage dice.
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDice = nCasterLvl;
    if (nDice > 15) nDice = 15;

    int damageType = SPGetElementalDamageType(DAMAGE_TYPE_ACID);
    // Acid storm is a huge burst doing 1d6 / lvl acid damage (15 cap)
    DoBurst (nCasterLvl,6, 0, nDice,
        AOE_PER_STORM, VFX_IMP_ACID_S,
        RADIUS_SIZE_HUGE, damageType, damageType, SPGetElementalSavingThrowType(SAVING_THROW_TYPE_ACID),
        FALSE, SPELL_SCHOOL_EVOCATION, GetSpellId(), 6.0);

    // Add some extra sfx.
    PlaySound("sco_swar3blue");
}
