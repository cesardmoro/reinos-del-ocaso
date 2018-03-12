/*
// As cure light wounds, except cure moderate wounds
// cures 2d8 points of damage plus 1 point per
// caster level (up to +10).
*/

#include "prc_class_const"

void main()
{
      object oPC = OBJECT_SELF;
      int nLevel = GetLevelByClass(CLASS_TYPE_RUNESCARRED,oPC);

      effect eCure = EffectHeal(d8(2) + nLevel);

      effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);

      effect eLink = EffectLinkEffects(eCure,eVis);

      ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oPC);
}