//:://////////////////////////////////////////////////
//:: X0_CH_HEN_CONV
/*

  OnDialogue event handler for henchmen/associates.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////

#include "prc_alterations"
#include "x0_inc_henai"
#include "x0_i0_henchman"

//* GeorgZ - Put in a fix for henchmen talking even if they are petrified
int AbleToTalk(object oSelf)
{
   if (GetHasEffect(EFFECT_TYPE_CONFUSED, oSelf) || GetHasEffect(EFFECT_TYPE_DOMINATED, oSelf) ||
        GetHasEffect(EFFECT_TYPE_PETRIFY, oSelf) || GetHasEffect(EFFECT_TYPE_PARALYZE, oSelf)   ||
        GetHasEffect(EFFECT_TYPE_STUNNED, oSelf) || GetHasEffect(EFFECT_TYPE_FRIGHTENED, oSelf)
    )
    {
        return FALSE;
    }

   return TRUE;
}


#include "x0_i0_henchman"


void main()
{

    if (GetIsHenchmanDying() == TRUE)
    {
        return;
    }

    object oShouter = GetLastSpeaker();
    object oMaster = GetMaster();
    object oIntruder;
    int nMatch = GetListenPatternNumber();

    if (nMatch == -1)
    {
        // * September 2 2003
        // * Added the GetIsCommandable check back in so that
        // * Henchman cannot be interrupted when they are walking away
        if (GetCommandable(OBJECT_SELF) == TRUE && AbleToTalk(OBJECT_SELF)
           && (GetCurrentAction() != ACTION_OPENLOCK))
        {   //SetCommandable(TRUE);
            ClearActions(CLEAR_X0_CH_HEN_CONV_26);


            string sDialogFileToUse = GetDialogFileToUse(GetLastSpeaker());


            BeginConversation(sDialogFileToUse);
        }
    }
    else
    {
        // listening pattern matched
        if (GetIsObjectValid(oMaster))
        {
            // we have a master, only listen to them
            // * Nov 2003 - Added an AbleToTalk, so that henchmen
            // * do not respond to orders when 'frozen'
            if (GetIsObjectValid(oShouter) && oMaster == oShouter && AbleToTalk(OBJECT_SELF)) {
                SetCommandable(TRUE);
                bkRespondToHenchmenShout(oShouter, nMatch, oIntruder);
            }
        }

        // we don't have a master, behave in default way
        else if (GetIsObjectValid(oShouter)
                 && !GetIsPC(oShouter)
                 && GetIsFriend(oShouter)) {

             object oIntruder = OBJECT_INVALID;

             // Determine the intruder if any
             if(nMatch == 4) {
                 oIntruder = GetLocalObject(oShouter, "NW_BLOCKER_INTRUDER");
             }
             else if (nMatch == 5) {
                 oIntruder = GetLastHostileActor(oShouter);
                 if(!GetIsObjectValid(oIntruder)) {
                     oIntruder = GetAttemptedAttackTarget();
                     if(!GetIsObjectValid(oIntruder)) {
                         oIntruder = GetAttemptedSpellTarget();
                     }
                 }
             }

             // Actually respond to the shout
             RespondToShout(oShouter, nMatch, oIntruder);
         }
    }


    // Signal user-defined event
    if(GetSpawnInCondition(NW_FLAG_ON_DIALOGUE_EVENT)) {
        SignalEvent(OBJECT_SELF, EventUserDefined(EVENT_DIALOGUE));
    }
}

