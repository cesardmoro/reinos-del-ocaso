/////////////////////////////////////////////////////////////////////
//
// Greater Firestorm - Burst of fire centered on the caster doing
// 1d8/lvl, max 15d8
//
/////////////////////////////////////////////////////////////////////

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

    int nDamageType = SPGetElementalDamageType(DAMAGE_TYPE_FIRE);
    // Acid storm is a huge burst doing 1d6 / lvl acid damage (15 cap)
    DoBurst (nCasterLvl,8, 0, nDice,
        VFX_FNF_FIREBALL, VFX_IMP_FLAME_M,
        RADIUS_SIZE_MEDIUM, nDamageType, nDamageType, SPGetElementalSavingThrowType(SAVING_THROW_TYPE_FIRE), TRUE);
}
