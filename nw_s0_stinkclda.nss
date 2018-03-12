//::///////////////////////////////////////////////
//:: Stinking Cloud On Enter
//:: NW_S0_StinkCldA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Those within the area of effect must make a
    fortitude save or be dazed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_STINKING_CLOUD,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    effect eStink = EffectDazed();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eMind, eStink);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());

    //Get the first object in the persistant area
    oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STINKING_CLOUD));
        //Make a SR check
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
        {
            //Make a Fort Save
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,GetAreaOfEffectCreator())), SAVING_THROW_TYPE_POISON))
            {
               fDelay = GetRandomDelay(0.75, 1.75);
               //Apply the VFX impact and linked effects
               if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
               {
                   DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                   DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
               }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
