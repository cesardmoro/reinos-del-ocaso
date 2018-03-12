/*:://////////////////////////////////////////////
//:: Name Fear Heartbeat
//:: FileName phs_ail_fear
//:://////////////////////////////////////////////
    This is the fear heartbeat, for PCs and NPCs, who have this effect on them:

    // Create a Frighten effect
    effect EffectFrightened()

    It isn't to 3.5E standard, but will try to be, but:

    For now:

    May attack with best HTH weapon if there are nearby allies, and a fear test
    is passed which is against 11 + enemies HD.

    It will counter attack. This means, if it has already run, it may just be not
    frightened enough to attack a lesser target, or even the original one if
    they are saved against.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: July+
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
