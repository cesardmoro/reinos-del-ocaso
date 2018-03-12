//::///////////////////////////////////////////////
//:: Owl's Insight
//:: x0_S0_OwlIns
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target's widsom bonus becomes equal to half caster's level
    Duration: 1 hr/ caster level
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:://////////////////////////////////////////////
//:: July 2002: Modified for Owl's Insight

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eRaise;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);


    int nMetaMagic = GetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nRaise = CasterLvl / 2;
    int nDuration = CasterLvl;

    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Set Adjust Ability Score effect
    eRaise = EffectAbilityIncrease(ABILITY_WISDOM, nRaise);
    effect eLink = EffectLinkEffects(eRaise, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 438, FALSE));

    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}


