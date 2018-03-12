//::///////////////////////////////////////////////
//:: Default On Attacked
//:: NW_C2_DEFAULT5
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If already fighting then ignore, else determine
    combat round
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 16, 2001
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"
#include "pw_inc"

void main()
{
    if(!GetIsObjectValid(GetAttemptedAttackTarget()) && !GetIsObjectValid(GetAttemptedSpellTarget()))
    {
        if(GetIsObjectValid(GetLastAttacker()))
        {
            if(GetArea(GetLastAttacker()) == GetArea(OBJECT_SELF))
            {
                PWDetermineCombatRound();
            }
            //Shout Attack my target, only works with the On Spawn In setup
            SpeakString("NW_ATTACK_MY_TARGET", TALKVOLUME_SILENT_TALK);
            //Shout that I was attacked
            SpeakString("NW_I_WAS_ATTACKED", TALKVOLUME_SILENT_TALK);
        }
    }

    if(GetSpawnInCondition(NW_FLAG_ATTACK_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1005));
    }
}
