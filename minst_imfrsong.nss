//::///////////////////////////////////////////////
//:: Immunity To Fear Song
//:://////////////////////////////////////////////
/*
 Makes allies immune to fear for the duration of the song.
*/
#include "prc_alterations"
#include "prc_class_const"
#include "prc_inc_clsfunc"

void main()
{
   if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
   {
        FloatingTextStrRefOnCreature(85587,OBJECT_SELF); // no more bardsong uses left
        return;
   }

    if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    //Declare major variables
    object oTarget;
    effect eImFear = EffectImmunity(IMMUNITY_TYPE_FEAR);
    effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eImFear, eDur);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);

    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nDuration = 10;
    location lSpell = PRCGetSpellTargetLocation();

    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nDuration *= 10;
    }

    if(GetHasFeat(424)) // lingering song
    {
        nDuration += 5;
    }

    RemoveOldSongEffects(OBJECT_SELF,GetSpellId());

    //Do the visual effects
    effect eVis2 = EffectVisualEffect(VFX_DUR_BARD_SONG);
    effect eLink2 = EffectLinkEffects(eVis2,eLink);

    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, PRCGetSpellTargetLocation());

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    //Cycle through the targets within the spell shape until an invalid object is captured or the number of
    //targets affected is equal to the caster level.
    while(GetIsObjectValid(oTarget))
    {
        //Make faction check on the target
        if(oTarget == OBJECT_SELF)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
        }
        else if(GetIsFriend(oTarget))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lSpell);
    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
