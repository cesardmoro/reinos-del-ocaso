//::///////////////////////////////////////////////
//:: Default On Damaged
//:: NW_C2_DEFAULT6
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
        if(GetIsObjectValid(GetLastDamager()))
        {
            PWDetermineCombatRound();
        }
    }
    else if (!GetIsObjectValid(GetAttemptedSpellTarget()))
    {
        object oTarget = GetAttackTarget();
        if(!GetIsObjectValid(oTarget))
        {
            oTarget = GetAttemptedAttackTarget();
        }
        object oAttacker = GetLastHostileActor();
        if (GetIsObjectValid(oAttacker) && oTarget != oAttacker && GetIsEnemy(oAttacker) &&
           (GetTotalDamageDealt() > (GetMaxHitPoints(OBJECT_SELF) / 4) ||
            (GetHitDice(oAttacker) - 2) > GetHitDice(oTarget) ) )
        {
            PWDetermineCombatRound(oAttacker);
        }
    }

    if(GetSpawnInCondition(NW_FLAG_DAMAGED_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1006));
    }
}
