#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget  = GetSpellTargetObject();

    effect eAttackBonus = EffectAttackIncrease(2);
    effect eACPenalty = EffectACDecrease(4);
    effect eDummy;

    effect eLinked = EffectLinkEffects(eAttackBonus, eACPenalty);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinked, oPC, 6.0);

    PerformAttackRound(oTarget, oPC, eDummy);
}