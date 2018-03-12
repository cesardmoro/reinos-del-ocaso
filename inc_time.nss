/** @file
    This set of functions controlls time for players. Each players individual time ahead
    of the server is tracked by a local float TimeAhead which is a second count.
    When recalculate time is called, the clock advances to that of the most behind player.

    This system works best with single party modules. If you have multiple parties and player
    you may find that when the server catches up it may disorent players for a time.

    @author Primogenitor
*/

//////////////////////////////////////////////////
/* Function Prototypes                          */
//////////////////////////////////////////////////

void AdvanceTimeForPlayer(object oPC, float fSeconds);


//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "prc_inc_switch"  // Needs direct include instead of inc_utility


//////////////////////////////////////////////////
/* Function Definitions                         */
//////////////////////////////////////////////////

void RecalculateTime()
{
    if(!GetPRCSwitch(PRC_PLAYER_TIME))
        return;
    object oPC = GetFirstPC();
    float fLowestAhead = GetLocalFloat(oPC, "TimeAhead");
    while(GetIsObjectValid(oPC))
    {
        if(GetLocalFloat(oPC, "TimeAhead") < fLowestAhead)
            fLowestAhead = GetLocalFloat(oPC, "TimeAhead");
        oPC = GetNextPC();
    }
    if(fLowestAhead == 0.0)
        return;
    if(fLowestAhead > 6.0)
        fLowestAhead = 6.0;//dont skip more than a round at a time
    SetTime(GetTimeHour(), GetTimeMinute(),
        GetTimeSecond()+FloatToInt(fLowestAhead), GetTimeMillisecond());
    oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        SetLocalFloat(oPC, "TimeAhead", GetLocalFloat(oPC, "TimeAhead")-fLowestAhead);
        oPC = GetNextPC();
    }
    DelayCommand(0.01, RecalculateTime());//do it again untill caught up
}


void AdvanceTimeForPlayer(object oPC, float fSeconds)
{
    SetLocalFloat(oPC, "TimeAhead", GetLocalFloat(oPC, "TimeAhead")+fSeconds);
    RecalculateTime();
}