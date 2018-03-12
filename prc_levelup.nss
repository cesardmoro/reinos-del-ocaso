/*
    Put into: OnLevelup Event
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius and DarkGod
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////

//Added hook into EvalPRCFeats event
//  Aaon Graywolf - Jan 6, 2004
//Added delay to EvalPRCFeats event to allow module setup to take priority
//  Aaon Graywolf - Jan 6, 2004



#include "x2_inc_switches"
#include "prc_inc_function"
#include "inc_item_props"

void PrcFeats(object oPC)
{
     EvalPRCFeats(oPC);
     if (GetLevelByClass(CLASS_TYPE_WEREWOLF, oPC) > 0)
     {
        ExecuteScript("prc_wwunpoly", oPC);
     }
}

void main()
{
    object oPC = GetPCLevellingUp();
    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);

    //All of the PRC feats have been hooked into EvalPRCFeats
    //The code is pretty similar, but much more modular, concise
    //And easy to maintain.
    //  - Aaon Graywolf
    DelayCommand(0.1, PrcFeats(oPC));

    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the newly leveled up player meets.
    ExecuteScript("prc_prereq", oPC);
    ExecuteScript("prc_enforce_feat", oPC);
    //Restore Power Points for Psionics
    ExecuteScript("prc_psi_ppoints", oPC);
    ExecuteScript("prc_enforce_psi", oPC);
    DelayCommand(1.0, FeatSpecialUsePerDay(oPC));

    // These scripts fire events that should only happen on levelup
    ExecuteScript("prc_vassal_treas", oPC);
}
