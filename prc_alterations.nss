//
//   This is the original include file for the PRC Spell Engine.
//
//   Various spells, components and designs within this system have
//   been contributed by many individuals within and without the PRC.
//

// Generic includes
#include "x2_inc_switches"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_racial_const"

#include "rdo_const_skill"

// PRC Spell Engine Utility Functions
#include "lookup_2da_spell"
#include "prcsp_reputation"
#include "prcsp_archmaginc"
#include "prcsp_spell_adjs"
#include "prcsp_engine"
#include "prc_inc_racial"
#include "prc_inc_combat"
#include "inc_debug"

#include "rdo_spinc"

// Checks if target is a frenzied Bersker with Deathless Frenzy Active
// If so removes imortality flag so that Death Spell can kill them
void DeathlessFrenzyCheck(object oTarget);

const int SAVING_THROW_NONE = 4;

// Added by Oni5115
void DeathlessFrenzyCheck(object oTarget)
{
     if(GetHasFeat(FEAT_DEATHLESS_FRENZY, oTarget) && GetHasFeatEffect(FEAT_FRENZY, oTarget) )
     {
          SetImmortal(oTarget, FALSE);
     }
}


object GetObjectToApplyNewEffect(string sTag, object oPC, int nStripEffects = TRUE);
object GetObjectToApplyNewEffect(string sTag, object oPC, int nStripEffects = TRUE)
{
    object oWP = GetObjectByTag(sTag);
    object oLimbo = GetObjectByTag(RDO_EffectCreators_WAYPOINT);
    location lLimbo = GetLocation(oLimbo);
    if(!GetIsObjectValid(oLimbo))
        lLimbo = GetStartingLocation();
    //not valid, create it
    if(!GetIsObjectValid(oWP))
    {
        //has to be a creature so it can be jumped around
        //re-used the 2da cache blueprint since it has no scripts
        oWP = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache", lLimbo, FALSE, sTag);
    }
    if(!GetIsObjectValid(oWP)
        && DEBUG)
    {
        DoDebug(sTag+" is not valid");
    }
    //make sure the player can never interact with WP
    SetPlotFlag(oWP, TRUE);
    SetCreatureAppearanceType(oWP, APPEARANCE_TYPE_INVISIBLE_HUMAN_MALE);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oWP);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneGhost(), oWP);
    //remove previous effects
    if(nStripEffects)
    {
        effect eTest = GetFirstEffect(oPC);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectCreator(eTest) == oWP
                && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL)
            {
                if(DEBUG) DoDebug("Stripping previous effect");
                RemoveEffect(oPC, eTest);
            }
            eTest = GetNextEffect(oPC);
        }
    }
    //jump to PC
    //must be in same area to apply effect
    if(GetArea(oWP) != GetArea(oPC))
        AssignCommand(oWP,
            ActionJumpToObject(oPC));
    //jump back to limbo afterwards
    DelayCommand(0.1,
        AssignCommand(oWP,
            ActionJumpToObject(oLimbo)));
    return oWP;
}
