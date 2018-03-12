//::///////////////////////////////////////////////
//:: Ghost Step (Invisibility)
//:: prc_gfkill_gstep.nss
//:://////////////////////////////////////////////
/*
    Target creature becomes invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Stefan Johnson
//:: Created On: December 1, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "x2_inc_spellhook"
#include "prc_inc_clsfunc"


void main()
{
   object oCaster = OBJECT_SELF;
   int iContinue = 0;
   if ( GetHasEffect( EFFECT_TYPE_CHARMED, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_CONFUSED, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_CUTSCENE_PARALYZE, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_CUTSCENEIMMOBILIZE, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_DAZED, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_DOMINATED, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_FRIGHTENED, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_PARALYZE, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_PETRIFY, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_SLEEP, oCaster ) ) {
      iContinue++;
   }
   if ( GetHasEffect( EFFECT_TYPE_STUNNED, oCaster ) ) {
      iContinue++;
   }
   if ( iContinue > 0 ) {
      IncrementRemainingFeatUses(oCaster, FEAT_GFKILL_GHOST_STEP);
      return;
   } else {
      int iClassLevel = GetLevelByClass(CLASS_TYPE_GHOST_FACED_KILLER, oCaster);
      effect eEffect;
      if ( iClassLevel > 5 ) {
         eEffect = EffectEthereal();
      } else {
         eEffect = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
      }
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oCaster, RoundsToSeconds(1));
   }
}

