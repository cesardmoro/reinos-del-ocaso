/** @file
 * ECL handling.
 *
 * @author Primogenitor
 *
 * @todo  Primo, could you document this one? More details to header and comment function prototypes
 */

//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

int GetECL(object oTarget);
void GiveXPReward(object oPC, object oTarget, int nCR = 0);
void GiveXPRewardToParty(object oPC, object oTarget, int nCR = 0);

//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "inc_utility"

//////////////////////////////////////////////////
/* Function definitions                         */
//////////////////////////////////////////////////

int GetECL(object oTarget)
{
    int nLevel;
  // we need to use a derivation of the base xp formular to compute the
  // pc level based on total XP.
  //
  // base XP formula (x = pc level, t = total xp):
  //
  //   t = x * (x-1) * 500
  //
  // need to use some base math..
  // transform for pq formula use (remove brackets with x inside and zero right side)
  //
  //   x^2 - x - (t / 500) = 0
  //
  // use pq formula to solve it [ x^2 + px + q = 0, p = -1, q = -(t/500) ]...
  //
  // that's our new formular to get the level based on total xp:
  //   level = 0.5 + sqrt(0.25 + (t/500))
  //
    if(GetPRCSwitch(PRC_ECL_USES_XP_NOT_HD)
        && (GetIsPC(oTarget) || GetLocalInt(oTarget, "NPC_XP")))
        nLevel = FloatToInt(0.5 + sqrt(0.25 + ( IntToFloat(GetXP(oTarget)) / 500 )));
    else
        nLevel = GetHitDice(oTarget);
    int nRace = GetRacialType(oTarget);
    nLevel += StringToInt(Get2DACache("ECL", "LA", nRace));
    if(GetPRCSwitch(PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA))
        nLevel += StringToInt(Get2DACache("ECL", "RaceHD", nRace));
    return nLevel;
}

void GiveXPRewardToParty(object oPC, object oTarget, int nCR = 0)
{
    object oTest = GetFirstFactionMember(oPC, !GetPRCSwitch(PRC_XP_GIVE_XP_TO_NPCS));
    while(GetIsObjectValid(oTest))
    {
        float fDistance = GetDistanceToObject(oTest);
        int nLevelDist = abs(GetECL(oTest)-GetECL(oPC));
        int bAward = TRUE;
        if(fDistance < 0.0 && GetPRCSwitch(PRC_XP_MUST_BE_IN_AREA))
            bAward = FALSE;
        if(fDistance > IntToFloat(GetPRCSwitch(PRC_XP_MAX_PHYSICAL_DISTANCE)))
            bAward = FALSE;
        if(nLevelDist > GetPRCSwitch(PRC_XP_MAX_LEVEL_DIFF)
            && GetPRCSwitch(PRC_XP_MAX_LEVEL_DIFF))
            bAward = FALSE;

        if(bAward)
            GiveXPReward(oTest, oTarget, nCR);

        oTest = GetNextFactionMember(oPC, !GetPRCSwitch(PRC_XP_GIVE_XP_TO_NPCS));
    }

}

void GiveXPReward(object oPC, object oTarget, int nCR = 0)
{
    if(GetIsObjectValid(oTarget))
    {
        nCR = FloatToInt(GetChallengeRating(oTarget));
        if(GetPRCSwitch(PRC_XP_USE_ECL_NOT_CR))
            nCR = GetECL(oTarget);
    }
    if(nCR < 1)
        nCR = 1;
    if(nCR > 70)
        nCR = 70;
    int ECL = GetECL(oPC);
    if(ECL < 1)
        ECL = 1;
    if(ECL > 60)
        ECL = 60;
    int nBaseXP = StringToInt(Get2DACache("dmgxp", IntToString(nCR), ECL-1));
    if(nBaseXP == 0)
        return;

    //count the size of the party

    float fPartyCount;
    int nAssociateType;
    object oTest = GetFirstFactionMember(oPC, FALSE);
    while(GetIsObjectValid(oTest))
    {
        nAssociateType = GetAssociateType(oTest);
        if     (nAssociateType == ASSOCIATE_TYPE_NONE)
            fPartyCount += IntToFloat(GetPRCSwitch(PRC_XP_PC_PARTY_COUNT_x100))/100.0;
        else if(nAssociateType == ASSOCIATE_TYPE_HENCHMAN)
            fPartyCount += IntToFloat(GetPRCSwitch(PRC_XP_HENCHMAN_PARTY_COUNT_x100))/100.0;
        else if(nAssociateType == ASSOCIATE_TYPE_DOMINATED)
            fPartyCount += IntToFloat(GetPRCSwitch(PRC_XP_DOMINATED_PARTY_COUNT_x100))/100.0;
        else if(nAssociateType == ASSOCIATE_TYPE_ANIMALCOMPANION)
            fPartyCount += IntToFloat(GetPRCSwitch(PRC_XP_ANIMALCOMPANION_PARTY_COUNT_x100))/100.0;
        else if(nAssociateType == ASSOCIATE_TYPE_FAMILIAR)
            fPartyCount += IntToFloat(GetPRCSwitch(PRC_XP_FAMILIAR_PARTY_COUNT_x100))/100.0;
        else if(nAssociateType == ASSOCIATE_TYPE_SUMMONED)
            fPartyCount += IntToFloat(GetPRCSwitch(PRC_XP_SUMMONED_PARTY_COUNT_x100))/100.0;
        oTest = GetNextFactionMember(oPC, FALSE);
    }
    //incase something weird is happenening
    if(fPartyCount == 0.0)
        return;
    int nXPAward = FloatToInt(IntToFloat(nBaseXP)/fPartyCount);

    //now do multiclass penalty

    int nHighestClassLevel;
    int i;
    for(i=1;i<=3;i++)
    {
        int nClassLevel = PRCGetLevelByPosition(i,oPC);
        if(nClassLevel > nHighestClassLevel)
            nHighestClassLevel = nClassLevel;
    }
    float fPenalty;
    int nRace = GetRacialType(oPC);
    for(i=1;i<=3;i++)
    {
        int nClassLevel = PRCGetLevelByPosition(i,oPC);
        int nClass = PRCGetClassByPosition(i, oPC);
        if(nClassLevel > nHighestClassLevel
            && Get2DACache("classes", "XPPenalty", nClass) != "1"
            && Get2DACache("racialtypes", "Favored", nClass) != IntToString(nClass)
            && Get2DACache("racialtypes", "Favored", nClass) != "")
             fPenalty += 0.2;
    }
    fPenalty = 1.0-fPenalty;
    nXPAward = FloatToInt(IntToFloat(nXPAward)*fPenalty);

    //now the module slider
    nXPAward = FloatToInt(IntToFloat(nXPAward)*IntToFloat(GetPRCSwitch(PRC_XP_SLIDER_x100))/100.0);
    //now the individual slider
    float fPCAdjust = IntToFloat(GetLocalInt(oPC, PRC_XP_SLIDER_x100))/100.0;
    if(fPCAdjust == 0.0)
        fPCAdjust = 1.0;
    nXPAward = FloatToInt(IntToFloat(nXPAward)*fPCAdjust);
    if(nXPAward < 0)
        return;

    //actually give the XP
    if(GetIsPC(oPC))
    {
        if(GetPRCSwitch(PRC_XP_USE_SETXP))
            SetXP(oPC, GetXP(oPC)+nXPAward);
        else
            GiveXPToCreature(oPC, nXPAward);
    }
    else if(GetPRCSwitch(PRC_XP_GIVE_XP_TO_NPCS))
        SetLocalInt(oPC, "NPC_XP", GetLocalInt(oPC, "NPC_XP")+nXPAward);
}

//::///////////////////////////////////////////////
//:: Effective Character Level Experience Script
//:: ecl_exp
//:: Copyright (c) 2004 Theo Brinkman
//:://////////////////////////////////////////////
/*
Call ApplyECLToXP() from applicable heartbeat script(s)
to cause experience to be adjusted according to ECL.
*/
//:://////////////////////////////////////////////
//:: Created By: Theo Brinkman
//:: Last Updated On: 2004-07-28
//:://////////////////////////////////////////////
// CONSTANTS
const string sLEVEL_ADJUSTMENT = "ecl_LevelAdjustment";
const string sXP_AT_LAST_HEARTBEAT = "ecl_LastExperience";

void ApplyECLToXP(object oPC);

int GetXPForLevel(int nLevel)
{
    return nLevel*(nLevel-1)*500;
}

void ApplyECLToXP(object oPC)
{
    //this is done first because leadership uses it too
    int iCurXP = GetXP(oPC);
    if(!GetIsPC(oPC))
        iCurXP = GetLocalInt(oPC, "NPC_XP");
    //if dm reduces Xp to zero, set the local to match.
    if(iCurXP == 0)
        SetPersistantLocalInt(oPC, sXP_AT_LAST_HEARTBEAT, 0);
    int iLastXP = GetPersistantLocalInt(oPC, sXP_AT_LAST_HEARTBEAT);
    SetPersistantLocalInt(oPC, sXP_AT_LAST_HEARTBEAT, iCurXP);
    //abort if simple LA is disabled
    if(!GetPRCSwitch(PRC_XP_USE_SIMPLE_LA))
        return;
    int nRace = GetRacialType(oPC);
    int iLvlAdj = StringToInt(Get2DACache("ECL", "LA", nRace));
    if(GetPRCSwitch(PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA))
        iLvlAdj += StringToInt(Get2DACache("ECL", "RaceHD", nRace));
    if(iLvlAdj != 0 && iLastXP != iCurXP)
    {
        int iPCLvl = GetHitDice(oPC);
        // Get XP Ratio (multiply new XP by this to see what to subtract)
        float fRealXPToLevel = IntToFloat(GetXPForLevel(iPCLvl+1));
        float fECLXPToLevel = IntToFloat(GetXPForLevel(iPCLvl+1+iLvlAdj));
        float fXPRatio = 1.0 - (fRealXPToLevel/fECLXPToLevel);
        //At this point the ratio is based on total XP
        //This is not correct, it should be based on the XP required to reach
        //the next level.
        fRealXPToLevel = IntToFloat(iPCLvl*1000);
        fECLXPToLevel = IntToFloat((iPCLvl+iLvlAdj)*1000);
        fXPRatio = 1.0 - (fRealXPToLevel/fECLXPToLevel);

        float fXPDif = IntToFloat(iCurXP - iLastXP);
        int iXPDif = FloatToInt(fXPDif * fXPRatio);
        int newXP = iCurXP - iXPDif;
        SendMessageToPC(oPC, "XP gained since last heartbeat "+IntToString(FloatToInt(fXPDif)));
        SendMessageToPC(oPC, "Real XP to level: "+IntToString(FloatToInt(fRealXPToLevel)));
        SendMessageToPC(oPC, "ECL XP to level:  "+IntToString(FloatToInt(fECLXPToLevel)));
        SendMessageToPC(oPC, "Level Adjustment +"+IntToString(iLvlAdj)+". Reducing XP by " + IntToString(iXPDif));
        if(GetIsPC(oPC))
            SetXP(oPC, newXP);
        else
            SetLocalInt(oPC, "NPC_XP", newXP);
        SetPersistantLocalInt(oPC, sXP_AT_LAST_HEARTBEAT, newXP);
    }
}
