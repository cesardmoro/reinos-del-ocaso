//::///////////////////////////////////////////////
//:: Default: End of Combat Round
//:: NW_C2_DEFAULT3
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calls the end of combat script every round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"
#include "pw_inc"

void main()
{
    if((GetCurrentHitPoints(GetAttackTarget())<GetLocalInt(OBJECT_SELF,"PW_DAMAGE")))
    {
        //the hit damaged them.  lets swallow them
        PWSwallow(GetAttackTarget());
    }

    DeleteLocalInt(OBJECT_SELF,"PW_DAMAGE");
    PWDetermineCombatRound();


    if(GetSpawnInCondition(NW_FLAG_END_COMBAT_ROUND_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1003));
    }
}


