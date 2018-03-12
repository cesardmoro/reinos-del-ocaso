//:Ghost Sight for Ghost-Faced Killer

#include "prc_alterations"

void main () {
   object oPC = OBJECT_SELF;
   if ( GetHasFeat( FEAT_GHOST_SIGHT, oPC ) ) {
      effect eSeeInvis = SupernaturalEffect(EffectSeeInvisible());
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSeeInvis, oPC);
   }
}
