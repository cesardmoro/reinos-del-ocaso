/*:://////////////////////////////////////////////
//:: Name Turning Heartbeat
//:: FileName phs_ail_turning
//:://////////////////////////////////////////////
    This runs on an creature with the effect EffectTurned().

    See fear heartbeat for tempoary, non-3.5E, fear effects.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

void main()
{
    //Allow the target to recieve commands for the round
    SetCommandable(TRUE);

    ClearAllActions();
    int nCnt = 1;
    int bValid;
    //Get the nearest creature to the affected creature
    object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
    float fDistance = GetDistanceBetween(OBJECT_SELF, oTarget);

    while (bValid == FALSE && GetIsObjectValid(oTarget) && fDistance <= 8.0)
    {
        if(GetIsEnemy(oTarget))
        {
            if(!WillSave(OBJECT_SELF, GetHitDice(oTarget) + 11, SAVING_THROW_TYPE_FEAR, oTarget))
            {
                //Run away if they are an enemy of the target's faction
                ActionMoveAwayFromObject(oTarget, TRUE);
            }
            else
            {
                ActionEquipMostDamagingMelee(oTarget);
                ActionAttack(oTarget);
            }
            bValid = TRUE;
        }
        //If not an enemy interate and find the next target
        nCnt++;
        oTarget = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF, nCnt);
        fDistance = GetDistanceBetween(OBJECT_SELF, oTarget);
    }
    //Disable the ability to recieve commands.
    SetCommandable(FALSE);
}
