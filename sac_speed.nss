#include "prc_class_const"
#include "prc_feat_const"
#include "nw_i0_spells"

void main()
{
    object oPC = GetSpellTargetObject();

    RemoveEffectsFromSpell(oPC, GetSpellId());

    int nLevel = GetLevelByClass(CLASS_TYPE_SACREDFIST,oPC);
    int iSpeed = (nLevel > 2) ? 10 : 0;
        iSpeed = (nLevel > 5) ? 20 : iSpeed;
        iSpeed = (nLevel > 7) ? 30 : iSpeed;

    if (GetHasFeat(FEAT_TYPE_ELEMENTAL, oPC) >= 10 && GetHasFeat(FEAT_BONDED_AIR,oPC))
        iSpeed += 30;

    if (iSpeed > 99) iSpeed = 99;

    ApplyEffectToObject(DURATION_TYPE_PERMANENT,ExtraordinaryEffect(EffectMovementSpeedIncrease(iSpeed)),oPC);
}
