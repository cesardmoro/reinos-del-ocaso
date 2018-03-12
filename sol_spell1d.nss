//::///////////////////////////////////////////////
//:: Protection from Evil
//:: NW_S0_PrEvil.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    When confronted by evil the protected character
    gains +2 AC, +2 to Saves and immunity to all
    mind-affecting spells cast by evil creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 28, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
#include "prc_inc_clsfunc"
#include "x2_inc_spellhook"

void main()
{
 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!CanCastSpell(1)) return;


    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    int Sol = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,OBJECT_SELF);

    //Declare major variables
    int nAlign = ALIGNMENT_EVIL;
    object oTarget = GetSpellTargetObject();
    int nDuration = Sol;
    //effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS);
    //Change the effects so that it only applies when the target is evil
    //Try wrapping the sanctuary effect in the Evil wrapper and see if the effect works.

    eAC = VersusAlignmentEffect(eAC,ALIGNMENT_ALL, nAlign);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, nAlign);
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    eImmune = VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, nAlign);
    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eImmune, eSave);
    eLink = EffectLinkEffects(eLink, eAC);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    //Apply the VFX impact and effects
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PROTECTION_FROM_EVIL, FALSE));
    //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,Sol);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

