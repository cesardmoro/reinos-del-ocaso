//::///////////////////////////////////////////////
//:: Orc Domain Power
//:: prc_domain_orc.nss
//::///////////////////////////////////////////////
/*
    Smite with damage bonus equal to cleric level.
    If the target is Elf or Dwarf, +4 on the attack
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_alterations"

void main()
{
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DOMAIN_POWER_ORC);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    effect eDummy = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    int nRace = MyPRCGetRacialType(oTarget);
    int nCleric = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
    int nBonus = 0;
    if (nRace == RACIAL_TYPE_ELF || nRace == RACIAL_TYPE_DWARF) nBonus = 4;

    PerformAttackRound(oTarget, oPC, eDummy, 0.0, nBonus, nCleric, DAMAGE_TYPE_BASE_WEAPON, FALSE, "Orc Domain Power Hit", "Orc Domain Power Miss");
}
