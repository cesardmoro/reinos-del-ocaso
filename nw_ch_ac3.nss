//::///////////////////////////////////////////////
//:: Associate: End of Combat End
//:: NW_CH_AC3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////
#include "X0_INC_HENAI"
#include "X2_inc_spellhook"
void main()
{
	//QUITADO: porque no esta en la versi�n original de bioware
	//if (bkCombatFollowMaster() == TRUE)
    //        return;

    if(!GetSpawnInCondition(NW_FLAG_SET_WARNINGS))
    {
       HenchmenCombatRound(OBJECT_INVALID);
    }


    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }

    // Check if concentration is required to maintain this creature
    X2DoBreakConcentrationCheck();
}

