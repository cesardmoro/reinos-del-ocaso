//::///////////////////////////////////////////////
//:: Silence Song
//:://////////////////////////////////////////////
/*
    Causes all creatures who fail their saving throw to be charmed
    for 10 rounds, 15 rounds with lingering song, and 105 rounds
    with lasting impression.
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
    int nLevel = GetLevelByClass(CLASS_TYPE_MINSTREL_EDGE);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA);
    int nDuration = 10; //+ nChr;
    int nDC = 10 + nLevel + nCha;
    if (GetHasFeat(FEAT_DRAGONSONG, OBJECT_SELF)) nDC+=2;

    //Check to see if the caster has Lasting Impression and increase duration.
    if(GetHasFeat(870))
    {
        nDuration *= 10;
    }

    if(GetHasFeat(424)) // lingering song
    {
        nDuration += 5;
    }

    effect eCharm;
    effect eCharmed = EffectCharmed();
    effect eCharmVis = EffectVisualEffect(VFX_IMP_SILENCE);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    RemoveOldSongEffects(OBJECT_SELF,GetSpellId());

    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
        eCharm = GetScaledEffect(eCharmed, oTarget);
        eCharm = EffectLinkEffects(eCharm, eMind);
        eCharm = EffectLinkEffects(eCharm, eDur);

        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            if (!GetHasEffect(EFFECT_TYPE_DEAF,oTarget)) // deaf targets can't hear the song.
            {
                if (GetIsImmune(oTarget, IMMUNITY_TYPE_SILENCE) == FALSE)
                {
                    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC))
                    {
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
                        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, RoundsToSeconds(nDuration), TRUE, GetSpellId(), nLevel);
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eCharmVis, oTarget);
                        StoreSongRecipient(oTarget, OBJECT_SELF, GetSpellId(), nDuration);
                    }
                }
            }
        }
        else
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget);
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);
}
