//::///////////////////////////////////////////////
//:: Wounding Whispers
//:://////////////////////////////////////////////
/*
   Bard song that gives everybody Wouding Whispers (with caster
   level being MotE level/3.)
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
    int nBonus = (GetLevelByClass(CLASS_TYPE_MINSTREL_EDGE, OBJECT_SELF) + 2) / 4;
    effect eBoost = EffectDamageShield(d6(1) + nBonus, 0, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_SONIC));
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eBoost, eDur);
    eLink = ExtraordinaryEffect(eLink);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);

    int iDontStack;

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
        iDontStack = GetHasSpellEffect(SPELL_WOUNDING_WHISPERS,oTarget);

        //Make faction check on the target
        if(oTarget == OBJECT_SELF && !iDontStack)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
        }
        else if(GetIsFriend(oTarget) && !iDontStack)
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
