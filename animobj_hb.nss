//:://////////////////////////////////////////////////
//:: X0_CH_HEN_HEART
/*

  OnHeartbeat event handler for henchmen/associates.

 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/05/2003
//:://////////////////////////////////////////////////
#include "prc_alterations"
#include "X0_INC_HENAI"



void main()
{    // SpawnScriptDebugger();

    // If the henchman is in dying mode, make sure
    // they are non commandable. Sometimes they seem to
    // 'slip' out of this mode
    int bDying = GetIsHenchmanDying();

    if (bDying == TRUE)
    {
        int bCommandable = GetCommandable();
        if (bCommandable == TRUE)
        {
            // lie down again
            ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,
                                          1.0, 65.0);
           SetCommandable(FALSE);
        }
    }

    // If we're dying, we return
    // (without sending the user-defined event)
    if(bDying)
        return;

    //SpeakString("HB");
    //animated objects stop animating after casterlvl rounds
    int iRoundsToGo = GetLocalInt(OBJECT_SELF,"Rounds");
    if (iRoundsToGo<=0)
    {
        ExecuteScript("animobj_killself", OBJECT_SELF);
        return;
    }
    SetLocalInt(OBJECT_SELF,"Rounds",iRoundsToGo - 1);

    //dismisle
    object oMasterCheck = GetMaster();
    if (!GetIsObjectValid(oMasterCheck))
    {
        ExecuteScript("animobj_killself", OBJECT_SELF);
        return;
    }

    // If we're busy, we return
    // (without sending the user-defined event)
    if(GetAssociateState(NW_ASC_IS_BUSY))
        return;

    // Check to see if should re-enter stealth mode
    if (GetIsInCombat() == FALSE)
    {
        if(GetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE") == 1
            && GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == FALSE)
            {
                SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
            }
    }

    // * checks to see if a ranged weapon was being used
    // * if so, it equips it back
    if (GetIsInCombat() == FALSE)
    {        //   SpawnScriptDebugger();
        object oRight = GetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND");
        if (GetIsObjectValid(oRight) == TRUE)
        {    // * you always want to blank this value, if it not invalid
            SetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND", OBJECT_INVALID);
            if (GetWeaponRanged(oRight) == TRUE)
            {
                ClearAllActions();
                bkEquipRanged(OBJECT_INVALID, TRUE, TRUE);
                //ActionEquipItem(
                return;

            }
        }
    }



    ExecuteScript("nw_ch_ac1", OBJECT_SELF);
}



