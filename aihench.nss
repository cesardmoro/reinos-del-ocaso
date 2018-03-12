#include "j_inc_constants"
const int NW_ASC_HAVE_MASTER =         0x80000000;
const int NW_ASC_DISTANCE_2_METERS =   0x00000001;
const int NW_ASC_DISTANCE_4_METERS =   0x00000002;
const int NW_ASC_DISTANCE_6_METERS =   0x00000004;
const string sAssociateMasterConditionVarname = "NW_ASSOCIATE_MASTER";

int GetAssociateState(int nCondition, object oAssoc=OBJECT_SELF)
{
    //SpawnScriptDebugger();
    if(nCondition == NW_ASC_HAVE_MASTER)
    {
        if(GetIsObjectValid(GetMaster(oAssoc)))
            return TRUE;
    }
     else
    {
        int nPlot = GetLocalInt(oAssoc, sAssociateMasterConditionVarname);
        if(nPlot & nCondition)
            return TRUE;
    }

    return FALSE;
}
float GetFollowDistance()
{
    float fDistance;
    if(GetAssociateState(NW_ASC_DISTANCE_2_METERS))
    {
        fDistance = 2.0;
    }
    else if(GetAssociateState(NW_ASC_DISTANCE_4_METERS))
    {
        fDistance = 4.0;
    }
    else if(GetAssociateState(NW_ASC_DISTANCE_6_METERS))
    {
        fDistance = 6.0;
    }

    return fDistance;
}
int GetHasEffect(int nEffectType, object oTarget = OBJECT_SELF)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == nEffectType)
        {
             return TRUE;
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}

int bkEvaluationSanityCheck(object oIntruder, float fFollow)
{
    // Pausanias: sanity check for various effects
    if (GetHasEffect(EFFECT_TYPE_PARALYZE) ||
        GetHasEffect(EFFECT_TYPE_STUNNED) ||
        GetHasEffect(EFFECT_TYPE_FRIGHTENED) ||
        GetHasEffect(EFFECT_TYPE_SLEEP) ||
        GetHasEffect(EFFECT_TYPE_DAZED))
        return TRUE;

    // * no point in seeing if intruder has same master if no valid intruder
    if (!GetIsObjectValid(oIntruder))
        return FALSE;

    // Pausanias sanity check: do not attack target
    // if you share the same master.
    object oMaster = GetMaster();
    int iHaveMaster = GetIsObjectValid(oMaster);
    if (iHaveMaster && GetMaster(oIntruder) == oMaster)
        return TRUE;

    return FALSE; //* COntinue on with DetermineCombatRound
}
void main()
{

if (bkEvaluationSanityCheck(GetAttackTarget(OBJECT_SELF), GetFollowDistance()) == TRUE)
        return;

    // ** Store HOw Difficult the combat is for this round
    int nDiff = FloatToInt(GetChallengeRating(GetAttackTarget(OBJECT_SELF)));
    SetLocalInt(OBJECT_SELF, "NW_L_COMBATDIFF", nDiff);
DetermineCombatRound(GetAttackTarget(OBJECT_SELF));
}
