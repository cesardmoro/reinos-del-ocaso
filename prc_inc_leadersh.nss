//////////////////////////////////////////////////
/*                 Constants                    */
//////////////////////////////////////////////////

const string PRC_PC_EXEC_DEFAULT = "PRC_PC_EXEC_DEFAULT";
const string CHANGE_PREFIX_LOCAL = "PRC_";
const string COHORT_DATABASE     = "PRCCOHORTS";
const string COHORT_TAG          = "prc_cohort";

//in the database there is the folloxing data structures:
/*
    int    CohortCount      (total number of cohorts)
    object Cohort_X_obj     (cohort itself)
    string Cohort_X_name    (cohort name)
    int    Cohort_X_race    (cohort race)
    int    Cohort_X_class1  (cohort class pos1)
    int    Cohort_X_class2  (cohort class pos2)
    int    Cohort_X_class3  (cohort class pos3)
    int    Cohort_X_order   (cohort law/chaos measure)
    int    Cohort_X_moral   (cohort good/evil measure)
    int    Cohort_X_ethran  (cohort has ethran feat)
    string Cohort_X_cdkey   (cdkey of owning player)
*/

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

int GetMaximumCohortCount(object oPC);
object GetCohort(int nID, object oPC);
int GetCurrentCohortCount(object oPC);
int GetCohortMaxLevel(int nLeadership, object oPC);
void RegisterAsCohort(object oPC);
void AddCohortToPlayer(int nCohortID, object oPC);
void RemoveCohortFromPlayer(object oCohort, object oPC);
int GetLeadershipScore(object oPC = OBJECT_SELF);
void CheckHB();


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "prc_feat_const"
#include "inc_utility"


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void AddCohortToPlayer(int nCohortID, object oPC)
{
    object oCohort = RetrieveCampaignObject(COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_obj", GetLocation(oPC));
    //give it a tag
    DestroyObject(oCohort);
    oCohort = CopyObject(oCohort, GetLocation(oPC), OBJECT_INVALID, COHORT_TAG);
    //add it to the pc
    int nMaxHenchmen = GetMaxHenchmen();
    SetMaxHenchmen(99);
    AddHenchman(oPC, oCohort);
    SetMaxHenchmen(nMaxHenchmen);
    //turn on its default script
    SetLocalInt(oCohort, "PRC_PC_EXEC_DEFAULT", TRUE);
    //set it to a conversation
    SetLocalString(oCohort, CHANGE_PREFIX_LOCAL+"conv", "prc_ai_coh_conv");
    SetLocalString(oCohort, CHANGE_PREFIX_LOCAL+"heartbeat", "prc_ai_coh_hb");
    //set it to the pcs level
    int nLevel = GetCohortMaxLevel(GetLeadershipScore(oPC), oPC);
    SetXP(oCohort, nLevel*(nLevel-1)*500);
    DelayCommand(1.0, AssignCommand(oCohort, SetIsDestroyable(FALSE, TRUE, TRUE)));
    DelayCommand(1.0, AssignCommand(oCohort, SetLootable(oCohort, TRUE)));

    //strip its equipment & inventory
    object oTest = GetFirstItemInInventory(oCohort);
    while(GetIsObjectValid(oTest))
    {
        if(GetHasInventory(oTest))
        {
            object oTest2 = GetFirstItemInInventory(oTest);
            while(GetIsObjectValid(oTest2))
            {
                DestroyObject(oTest2);
                oTest = GetNextItemInInventory(oTest);
            }
        }
        DestroyObject(oTest);
        oTest = GetNextItemInInventory(oCohort);
    }
    int nSlot;
    for(nSlot = 0;nSlot<14;nSlot++)
    {
         DestroyObject(oTest);
    }

    //DEBUG
    //various tests
    DoDebug("Cohort Name="+GetName(oCohort));
    DoDebug("Cohort HD="+IntToString(GetHitDice(oCohort)));
    DoDebug("Cohort XP="+IntToString(GetXP(oCohort)));
    DoDebug("Cohort GetIsPC="+IntToString(GetIsPC(oCohort)));
}

void RemoveCohortFromPlayer(object oCohort, object oPC)
{
    int nValidPC = FALSE;
    if(GetIsObjectValid(oPC))
        nValidPC = TRUE;

    //strip its equipment & inventory
    object oTest = GetFirstItemInInventory(oCohort);
    while(GetIsObjectValid(oTest))
    {
        if(GetHasInventory(oTest))
        {
            object oTest2 = GetFirstItemInInventory(oTest);
            while(GetIsObjectValid(oTest2))
            {
                if(nValidPC)
                    AssignCommand(oCohort, ActionGiveItem(oTest2, oPC));
                else
                    DestroyObject(oTest2);
                oTest = GetNextItemInInventory(oTest);
            }
        }
        if(nValidPC)
            AssignCommand(oCohort, ActionGiveItem(oTest, oPC));
        else
            DestroyObject(oTest);
        oTest = GetNextItemInInventory(oCohort);
    }
    int nSlot;
    for(nSlot = 0;nSlot<14;nSlot++)
    {
        if(nValidPC)
            AssignCommand(oCohort, ActionGiveItem(GetItemInSlot(nSlot, oCohort), oPC));
        else
            DestroyObject(oTest);
    }
    //now destroy it
    AssignCommand(oCohort, ActionDoCommand(SetIsDestroyable(TRUE, FALSE, FALSE)));
    AssignCommand(oCohort, ActionDoCommand(SetLootable(oCohort, FALSE)));
    AssignCommand(oCohort, ActionDoCommand(DestroyObject(oCohort)));
}

int GetLeadershipScore(object oPC = OBJECT_SELF)
{
    int nLeadership = GetECL(oPC);
    nLeadership += GetAbilityModifier(ABILITY_CHARISMA, oPC);
    //without epic leadership its capped at 25
    if(!GetHasFeat(FEAT_EPIC_LEADERSHIP, oPC) && nLeadership > 25)
        nLeadership = 25;

    return nLeadership;
}

void CheckHB()
{
    SetCommandable(FALSE);
    if(GetHitDice(OBJECT_SELF) == 40)
    {
        int nCohortCount = GetCampaignInt(COHORT_DATABASE, "CohortCount");
        int i;
        for(i=0;i<nCohortCount;i++)
        {
            if(GetCampaignInt(COHORT_DATABASE, "Cohort_"+IntToString(i)+"_deleted"))
            {
                nCohortCount = i;
            }
        }
        if(GetCampaignInt(COHORT_DATABASE, "CohortCount")==nCohortCount) //no "deleted" cohorts
            nCohortCount++;
        //store the player
        SetCampaignInt(COHORT_DATABASE, "CohortCount", nCohortCount);
        StoreCampaignObject(COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_obj",    OBJECT_SELF);
        SetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_name",   GetName(OBJECT_SELF));
        SetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_race",   GetRacialType(OBJECT_SELF));
        SetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_class1", PRCGetClassByPosition(1, OBJECT_SELF));
        SetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_class2", PRCGetClassByPosition(2, OBJECT_SELF));
        SetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_class3", PRCGetClassByPosition(3, OBJECT_SELF));
        SetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_order",  GetLawChaosValue(OBJECT_SELF));
        SetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_moral",  GetGoodEvilValue(OBJECT_SELF));
        SetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_ethran", GetHasFeat(FEAT_ETHRAN, OBJECT_SELF));
        SetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_cdkey",  GetPCPublicCDKey(OBJECT_SELF));
        SetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortCount)+"_deleted",   FALSE);

        //restore previous xp amound
        int nOldXP = GetLocalInt(OBJECT_SELF, "OriginalXP");
        SetXP(OBJECT_SELF, nOldXP);
        //tell the player what was done
        SendMessageToPC(OBJECT_SELF, "Character registered as cohort.");
        //remove the non-commandabiltiy
        //csp lowes dex, which stops leveling with certain feats
        SetCommandable(TRUE);
        //stop the psuedoHB
        return;
    }
    DelayCommand(1.0, CheckHB());
}

void RegisterAsCohort(object oPC)
{
    string sMessage;
    sMessage += "This will register you character to be selected as a cohort.\n";
    sMessage += "As part of this process, you have to levelup to level 40.\n";
    sMessage += "Once you reach level 40, your character will be stored.\n";
    sMessage += "Then when the character is used as a cohort, it will follow that levelup path.\n";
    sMessage += "Any changes to the cohort will not apply to the original character.\n";
    //SendMessageToPC(oPC, sMessage);
    FloatingTextStringOnCreature(sMessage, oPC);

    SetLocalInt(oPC, "OriginalXP", GetXP(oPC));
    SetXP(oPC, 40*(40-1)*500);
    AssignCommand(oPC, CheckHB());
}


int GetCohortMaxLevel(int nLeadership, object oPC)
{
    int nLevel;
    switch(nLeadership)
    {
        case  1: nLevel =  0; break;
        case  2: nLevel =  1; break;
        case  3: nLevel =  2; break;
        case  4: nLevel =  3; break;
        case  5: nLevel =  3; break;
        case  6: nLevel =  4; break;
        case  7: nLevel =  5; break;
        case  8: nLevel =  5; break;
        case  9: nLevel =  6; break;
        case 10: nLevel =  7; break;
        case 11: nLevel =  7; break;
        case 12: nLevel =  8; break;
        case 13: nLevel =  9; break;
        case 14: nLevel = 10; break;
        case 15: nLevel = 10; break;
        case 16: nLevel = 11; break;
        case 17: nLevel = 12; break;
        case 18: nLevel = 12; break;
        case 19: nLevel = 13; break;
        case 20: nLevel = 14; break;
        case 21: nLevel = 15; break;
        case 22: nLevel = 15; break;
        case 23: nLevel = 16; break;
        case 24: nLevel = 17; break;
        case 25: nLevel = 17; break;
        case 26: nLevel = 18; break;
        case 27: nLevel = 18; break;
        case 28: nLevel = 19; break;
        case 29: nLevel = 19; break;
        case 30: nLevel = 20; break;
        case 31: nLevel = 20; break;
        case 32: nLevel = 21; break;
        case 33: nLevel = 21; break;
        case 34: nLevel = 22; break;
        case 35: nLevel = 22; break;
        case 36: nLevel = 23; break;
        case 37: nLevel = 23; break;
        case 38: nLevel = 24; break;
        case 39: nLevel = 24; break;
        case 40: nLevel = 25; break;
        case 41: nLevel = 25; break;
        case 42: nLevel = 26; break;
        case 43: nLevel = 26; break;
        case 44: nLevel = 27; break;
        case 45: nLevel = 27; break;
        case 46: nLevel = 28; break;
        case 47: nLevel = 28; break;
        case 48: nLevel = 29; break;
        case 49: nLevel = 29; break;
        case 50: nLevel = 30; break;
        case 51: nLevel = 30; break;
        case 52: nLevel = 31; break;
        case 53: nLevel = 31; break;
        case 54: nLevel = 32; break;
        case 55: nLevel = 32; break;
        case 56: nLevel = 33; break;
        case 57: nLevel = 33; break;
        case 58: nLevel = 34; break;
        case 59: nLevel = 34; break;
        case 60: nLevel = 35; break;
        case 61: nLevel = 36; break;
        case 62: nLevel = 36; break;
        case 63: nLevel = 37; break;
        case 64: nLevel = 37; break;
        case 65: nLevel = 38; break;
        case 66: nLevel = 38; break;
        case 67: nLevel = 39; break;
        case 68: nLevel = 39; break;
        case 69: nLevel = 40; break;
        case 70: nLevel = 40; break;
    }
    if(nLevel > (GetHitDice(oPC)-2))
        nLevel = GetHitDice(oPC)-2;
    return nLevel;
}

int GetCurrentCohortCount(object oPC)
{
    int nCount;
    object oTest;
    object oOldTest;
    int i = 1;
    oTest = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
    while(GetIsObjectValid(oTest) && oTest != oOldTest)
    {
        if(GetTag(oTest) == COHORT_TAG)
            nCount++;
        i++;
        oOldTest = oTest;
        oTest = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
    }
    return nCount;
}

object GetCohort(int nID, object oPC)
{
    int nCount;
    object oTest;
    object oOldTest;
    int i = 1;
    oTest = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
    while(GetIsObjectValid(oTest) && oTest != oOldTest)
    {
        if(GetTag(oTest) == COHORT_TAG)
            nCount++;
        if(nCount == nID)
            return oTest;
        i++;
        oOldTest = oTest;
        oTest = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oPC, i);
    }
    return OBJECT_INVALID;
}

int GetMaximumCohortCount(object oPC)
{
    int nCount = 0;
    if(GetHasFeat(FEAT_LEADERSHIP, oPC))
        nCount++;
    if(GetHasFeat(FEAT_LEGENDARY_COMMANDER, oPC))
        nCount++;
    if(GetHasFeat(FEAT_HATH_COHORT, oPC))
        nCount++;
    nCount += GetPRCSwitch(PRC_BONUS_COHORTS);    
    return nCount;
}

int GetIsCohortChoiceValid(int nID, object oPC)
{
    int bIsValid = TRUE;
    string sName = GetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_name");
    int    nRace = GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_race");
    int    nClass1=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_class1");
    int    nClass2=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_class2");
    int    nClass3=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_class3");
    int    nOrder= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_order");
    int    nMoral= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_moral");
    int    nEthran=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_ethran");
    string sKey  = GetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_cdkey");
    int nCohortCount = GetMaximumCohortCount(oPC);
    int i;
    //another players cohort
    if(GetPCPublicCDKey(oPC) != "" && GetPCPublicCDKey(oPC) != sKey)
        bIsValid = FALSE;
    //is character
    if(GetName(oPC) == sName)
        bIsValid = FALSE;
    //is already a cohort
    for(i=1;i<=nCohortCount;i++)
    {
        object oCohort = GetCohort(i, oPC);
        if(GetName(oCohort) == sName)
            bIsValid = FALSE;
    }
    //has been deleted
    if(GetCampaignInt(COHORT_DATABASE, "Cohort_"+IntToString(nID)+"_deleted"))
        bIsValid = FALSE;
    //hathran
    if(GetHasFeat(FEAT_HATH_COHORT, oPC))
    {
        int nEthranBarbarianCount = 0;
        for(i=1;i<=nCohortCount;i++)
        {
            object oCohort = GetCohort(i, oPC);
            if(GetIsObjectValid(oCohort)
                &&(GetHasFeat(FEAT_HATH_COHORT, oCohort)
                    || GetLevelByClass(CLASS_TYPE_BARBARIAN, oCohort)))
                nEthranBarbarianCount++;
        }
        //must have at least one ethran or barbarian
        if(!nEthranBarbarianCount
            && GetCurrentCohortCount(oPC) >= GetMaximumCohortCount(oPC)-1
            && !nEthran
            && nClass1 != CLASS_TYPE_BARBARIAN
            && nClass2 != CLASS_TYPE_BARBARIAN
            && nClass3 != CLASS_TYPE_BARBARIAN)
                bIsValid = FALSE;
    }
    //Undead Leadership
    //Wild Cohort
        //not implemented yet
    //return result
    return bIsValid;
}

int GetCanRegister(object oPC)
{
    int bReturn = TRUE;
    int i;
    int nCohortCount = GetCampaignInt(COHORT_DATABASE, "CohortCount");
    for(i=0;i<nCohortCount;i++)
    {
        string sName = GetCampaignString(COHORT_DATABASE, "Cohort_"+IntToString(i)+"_name");
        if(sName == GetName(oPC))
            bReturn = FALSE;
    }
    return bReturn;
}

void DeleteCohort(int nCohortID)
{
    //this is a bit of a fudge, but it will do for now
    //Add Cohort overwrites the first deleted cohort
    SetCampaignInt(COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_deleted", TRUE);
}

// Test main
//void main(){}
