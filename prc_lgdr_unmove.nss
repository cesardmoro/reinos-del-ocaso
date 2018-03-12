//Unmovable
//prc_lgdr_unmove
//
/*
  Causes the PC to become near immobile and
  grants a 20+ Bonus to Discipline Checks.
*/
//
//

//#include "prc_aser_inc"
#include "x2_i0_spells"
void main()
{

        //Define Properties

        effect eSet = EffectMovementSpeedDecrease(99);
        effect eDisc;
        eDisc = EffectSkillIncrease(SKILL_DISCIPLINE, 20);
        effect eLinkSet = EffectLinkEffects(eSet, eDisc);

     if(!GetHasSpellEffect(SPELL_UNMOVABLE,OBJECT_SELF))
     {
        FloatingTextStringOnCreature("Unmovable Activated",OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eLinkSet,OBJECT_SELF);
        IncrementRemainingFeatUses(OBJECT_SELF,FEAT_UNMOVABLE_1);
     }
     else
     {
          // The code to cancel the effects
            RemoveSpellEffects(GetSpellId(), OBJECT_SELF, OBJECT_SELF);

          //RemoveEffect(OBJECT_SELF, eLinkSet);
     }



}
