//::///////////////////////////////////////////////
//:: Name: HeartBeat de CaballosDeeme
//:: FileName: eid_gsc_hb
//:: Copyright (c) 2005 ES] EIDOLOM
//:://////////////////////////////////////////////
/*
    Ordeno el script original y hago que las monturas se alejen antes de,
    simplemente, desaparecer.
    Las lineas 36 a 40 las anulo.
*/
//::
//:: Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
//::
//:://////////////////////////////////////////////
//:: Modified By: Deeme
//:: Modified On: 24/06/2005
//:://////////////////////////////////////////////


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

#include "X0_INC_HENAI"

void main()
{
    // SpawnScriptDebugger();
    /*
    object oWP = GetNearestObject(OBJECT_TYPE_WAYPOINT, OBJECT_SELF);

    if(GetMaster() == OBJECT_INVALID){
        AssignCommand(OBJECT_SELF, SetIsDestroyable(TRUE, FALSE, FALSE));
        AssignCommand(OBJECT_SELF, ActionForceMoveToObject(oWP, TRUE));
        //ActionMoveAwayFromObject(OBJECT_SELF, TRUE, 80.0f);
        DelayCommand(5.0, DestroyObject(OBJECT_SELF));
        return;
    }
    */

    // If the henchman is in dying mode, make sure they are non commandable.
    // Sometimes they seem to 'slip' out of this mode.
    int bDying = GetIsHenchmanDying();

    if(bDying == TRUE){
        int bCommandable = GetCommandable();
        if(bCommandable == TRUE){
            // lie down again
            ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 65.0);
            SetCommandable(FALSE);
        }
    }

    // If we're dying or busy, we return (without sending the user-defined
    // event)
    if(GetAssociateState(NW_ASC_IS_BUSY) || bDying)
        return;

    // Check to see if should re-enter stealth mode
    if(GetIsInCombat() == FALSE){
        int nStealth = GetLocalInt(OBJECT_SELF, "X2_HENCH_STEALTH_MODE");

        if((nStealth == 1 || nStealth == 2) && GetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH) == FALSE){
            SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
        }
    }

    // checks to see if a ranged weapon was being used if so, it equips it back
    if(GetIsInCombat() == FALSE){
        // SpawnScriptDebugger();
        object oRight = GetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND");

        if(GetIsObjectValid(oRight) == TRUE){
            // * you always want to blank this value, if it not invalid
            SetLocalObject(OBJECT_SELF, "X0_L_RIGHTHAND", OBJECT_INVALID);
            if(GetWeaponRanged(oRight) == TRUE){
                ClearAllActions();
                bkEquipRanged(OBJECT_INVALID, TRUE, TRUE);
                //ActionEquipItem(
                return;
            }
        }
    }

    ExecuteScript("nw_ch_ac1", OBJECT_SELF);
}

