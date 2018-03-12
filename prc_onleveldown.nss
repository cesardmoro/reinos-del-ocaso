//::///////////////////////////////////////////////
//:: OnLevelDown eventscript
//:: prc_onleveldown
//:://////////////////////////////////////////////
/** @file
    This script is a virtual event. It is fired
    when a check in module hearbeat detects a player's
    hit dice has dropped.
    It runs most of the same operations as prc_levelup
    in order to fully re-evaluate the character's
    class features that are granted by the PRC scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 09.06.2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_utility"
#include "psi_inc_psifunc"

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
    object oPC    = OBJECT_SELF;
    int nOldLevel = GetLocalInt(oPC, "PRC_OnLevelDown_OldLevel");

    object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
    DeletePRCLocalInts(oSkin);

    //All of the PRC feats have been hooked into EvalPRCFeats
    //The code is pretty similar, but much more modular, concise
    //And easy to maintain.
    //  - Aaon Graywolf
    PrcFeats(oPC);

    // For psionics characters, remove powers known on all lost levels
    if(GetIsPsionicCharacter(oPC))
    {
        int i = nOldLevel;
        for(; i > GetHitDice(oPC); i--)
            RemovePowersKnownOnLevel(oPC, i);
    }

    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the newly leveled up player meets.
    ExecuteScript("prc_prereq", oPC);

    // Execute scripts hooked to this event for the player triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONPLAYERLEVELDOWN);

    // Clear the old level value
    DeleteLocalInt(oPC, "PRC_OnLevelDown_OldLevel");
}
