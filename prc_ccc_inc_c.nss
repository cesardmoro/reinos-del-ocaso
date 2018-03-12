#include "inc_utility"
//#include "prc_inc_racial"
#include "prc_racial_const"
#include "prc_ccc_inc_d"

//the various delayed loops
//used when lots of intructions needed
//causes extreme lag

void PortraitLoop();
void FeatLoop(int nClassFeatStage = FALSE);
void ClassLoop();
void SoundsetLoop();
void SpellLoop();
void SkillLoop();
void BonusFeatLoop();
void AppearanceLoop();
void SoundsetLoop();
void WingLoop();
void TailLoop();

//this doenst feedback into the main convo
void DoClassFeat(string sClassFeatTable, int i=0);

void ClassLoop()
{
    string q = PRC_SQLGetTick();
    if(GetLocalInt(OBJECT_SELF, "DynConv_Waiting") == FALSE)
        return;
    int nReali = GetLocalInt(OBJECT_SELF, "i");
    string SQL = "SELECT "+q+"rowid"+q+" FROM "+q+"prc_cached2da_classes"+q+" WHERE ("+q+"PlayerClass"+q+" = 1) LIMIT 25 OFFSET "+IntToString(nReali);
    PRC_SQLExecDirect(SQL);
    int bAtLeastOneResult;
    array_create(OBJECT_SELF, "temp_classes");
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        bAtLeastOneResult = TRUE;
        int nClass = StringToInt(PRC_SQLGetData(1));
        array_set_int(OBJECT_SELF, "temp_classes", array_get_size(OBJECT_SELF, "temp_classes"), nClass);
    }
    int i;
    for(i=0;i<array_get_size(OBJECT_SELF, "temp_classes");i++)
    {
        int nClass = array_get_int(OBJECT_SELF, "temp_classes", i);
        if(CheckClassRequirements(nClass))
        {
            string sName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
            AddChoice(sName, nClass);
        }
    }
    array_delete(OBJECT_SELF, "temp_classes");

    if(!bAtLeastOneResult)
    {
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "i");
        return;
    }
    SetLocalInt(OBJECT_SELF, "i", nReali+25);
    DelayCommand(0.01, ClassLoop());
}

void SkillLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(GetLocalInt(OBJECT_SELF, "DynConv_Waiting") == FALSE)
        return;
    int nPoints = GetLocalInt(OBJECT_SELF, "Points");
    int nInt = GetLocalInt(OBJECT_SELF, "Int");
    int nClass = GetLocalInt(OBJECT_SELF, "Class");
    int nRace = GetLocalInt(OBJECT_SELF, "Race");
    int nLevel = GetLocalInt(OBJECT_SELF, "Level");
    if(nPoints== 0)
    {
        nPoints = StringToInt(Get2DACache("classes", "SkillPointBase", GetLocalInt(OBJECT_SELF, "Class")));
        nInt += StringToInt(Get2DACache("racialtypes", "IntAdjust", nRace));
        nPoints += ((nInt-10)/2);
        if(nPoints <1)
            nPoints = 1; //min 1point
        //QTM bonus
        if(nLevel == 0)
        {
            for(i=0;i<array_get_size(OBJECT_SELF, "Feats");i++)
            {
               if(array_get_int(OBJECT_SELF, "Feats", i) == FEAT_QUICK_TO_MASTER)
               {
                   nPoints++;
                }
            }
            int nMultiplier = GetPRCSwitch(PRC_CONVOCC_SKILL_MULTIPLIER);
            if(nMultiplier == 0)
                nMultiplier = 4;
            nPoints *= nMultiplier;
            nPoints += GetPRCSwitch(PRC_CONVOCC_SKILL_BONUS);
        }
        SetLocalInt(OBJECT_SELF, "Points", nPoints);
    }

    i = GetLocalInt(OBJECT_SELF, "i");
    if(i==0
        && GetPRCSwitch(PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER))
    {
        SetupSkillToken(-2, array_get_size(OBJECT_SELF, "ChoiceValue"));
        //SetupSkillToken(-1, array_get_size(OBJECT_SELF, "ChoiceValue"));
    }
    string sFile = Get2DACache("classes", "SkillsTable", nClass);
    if(i < GetPRCSwitch(FILE_END_SKILLS))
    {
        SetupSkillToken(i, array_get_size(OBJECT_SELF, "ChoiceValue"));
        i++;
        SetLocalInt(OBJECT_SELF, "i", i);
        DelayCommand(0.01, SkillLoop());
        return;
   }
   FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
   DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
   DeleteLocalInt(OBJECT_SELF, "Percentage");
   DeleteLocalInt(OBJECT_SELF, "i");
}

void FeatLoop(int nClassFeatStage = FALSE)
{
    int iMax = 5;

    //get some stored data
    object oPC = OBJECT_SELF;
    int nStr = GetLocalInt(oPC, "Str");
    int nDex = GetLocalInt(oPC, "Dex");
    int nCon = GetLocalInt(oPC, "Con");
    int nInt = GetLocalInt(oPC, "Int");
    int nWis = GetLocalInt(oPC, "Wis");
    int nCha = GetLocalInt(oPC, "Cha");
    int nRace = GetLocalInt(oPC, "Race");
    int nLevel = GetLocalInt(oPC, "Level");
    int nOrder = GetLocalInt(oPC, "LawfulChaotic");
    int nMoral = GetLocalInt(oPC, "GoodEvil");
    //add racial ability alterations
    nStr += StringToInt(Get2DACache("racialypes", "StrAdjust", nRace));
    nDex += StringToInt(Get2DACache("racialypes", "DexAdjust", nRace));
    nCon += StringToInt(Get2DACache("racialypes", "ConAdjust", nRace));
    nInt += StringToInt(Get2DACache("racialypes", "IntAdjust", nRace));
    nWis += StringToInt(Get2DACache("racialypes", "WisAdjust", nRace));
    nCha += StringToInt(Get2DACache("racialypes", "ChaAdjust", nRace));
    int j;
    for(j=1;j<=nLevel;j++)
    {
        //ability
        if(j == 3 || j == 7 || j == 11 || j == 15
                || j == 19 || j == 23 || j == 27 || j == 31
                || j == 13 || j == 39)
        {
            int nAbil = GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(j)+"Ability");
            switch(nAbil)
            {
                case ABILITY_STRENGTH:      nStr++;     break;
                case ABILITY_DEXTERITY:     nDex++;     break;
                case ABILITY_CONSTITUTION:  nCon++;     break;
                case ABILITY_INTELLIGENCE:  nInt++;     break;
                case ABILITY_WISDOM:        nWis++;     break;
                case ABILITY_CHARISMA:      nCha++;     break;
            }
        }
    }
    int nClass = GetLocalInt(oPC, "Class");
    int nSex = GetLocalInt(oPC, "Gender");
    int nBAB;
    for(j=0;j<=nLevel;j++)
    {
        nBAB += StringToInt(Get2DACache(Get2DACache("classes", "AttackBonusTable",nClass),"BAB",j));
    }
    int nCasterLevel;
    if(nClass == CLASS_TYPE_WIZARD
        || nClass == CLASS_TYPE_SORCERER
        || nClass == CLASS_TYPE_BARD
        || nClass == CLASS_TYPE_CLERIC
        || nClass == CLASS_TYPE_DRUID)
        nCasterLevel = 1;
    int nFortSave;
    for(j=0;j<=nLevel;j++)
    {
        nFortSave = StringToInt(Get2DACache(Get2DACache("classes","SavingThrowTable" , nClass), "FortSave", nLevel));
    }
    string sFeatList = Get2DACache("classes", "FeatsTable", nClass);
    sFeatList = GetStringLowerCase(sFeatList);

    string q = PRC_SQLGetTick();
    int i = GetLocalInt(OBJECT_SELF, "i");
    string SQL;
    if(nClassFeatStage == TRUE)
    {
        SQL = "SELECT "+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"FEAT"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"PREREQFEAT1"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"PREREQFEAT2"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat0"+q+","
            +" "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat1"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat2"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat3"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat4"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"REQSKILL"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"REQSKILL2"+q+","
            +" "+q+"prc_cached2da_feat"+q+"."+q+"ReqSkillMinRanks"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"ReqSkillMinRanks2"+q+""
            +" FROM "+q+"prc_cached2da_cls_feat"+q+" INNER JOIN "+q+"prc_cached2da_feat"+q+""
            +" WHERE (FEAT != '****')"
            +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"file"+q+" = '"+sFeatList+"')"
            +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"List"+q+" <= 1)"
            +" AND (("+q+"PreReqEpic"+q+" = '****') OR ("+q+"PreReqEpic"+q+" = 0))"
            +" AND (("+q+"ALLCLASSESCANUSE"+q+" = 0) OR ("+q+"ALLCLASSESCANUSE"+q+" = '****'))"
            +" AND ("+q+"MINATTACKBONUS"+q+" <= "+IntToString(nBAB)+")"
            +" AND ("+q+"MINSPELLLVL"+q+" <= "+IntToString(nCasterLevel)+")"
            +" AND ("+q+"MINSTR"+q+" <= "+IntToString(nStr)+")"
            +" AND ("+q+"MINDEX"+q+" <= "+IntToString(nDex)+")"
            +" AND ("+q+"MINCON"+q+" <= "+IntToString(nCon)+")"
            +" AND ("+q+"MININT"+q+" <= "+IntToString(nInt)+")"
            +" AND ("+q+"MINWIS"+q+" <= "+IntToString(nWis)+")"
            +" AND ("+q+"MINCHA"+q+" <= "+IntToString(nCha)+")"
            +" AND (("+q+"MaxLevel"+q+" = '****') OR ("+q+"MaxLevel"+q+" > "+IntToString(nLevel)+"))"
            +" AND ("+q+"MinFortSave"+q+" <= "+IntToString(nFortSave)+")"
            +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+" != '****')"
            +" AND ("+q+"prc_cached2da_feat"+q+"."+q+"rowid"+q+" = "+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+")"
            +" LIMIT "+IntToString(iMax)+" OFFSET "+IntToString(i);
    }
    else
    {
        SQL = "SELECT "+q+"rowid"+q+", "+q+"FEAT"+q+", "+q+"PREREQFEAT1"+q+", "+q+"PREREQFEAT2"+q+", "+q+"OrReqFeat0"+q+","
            +" "+q+"OrReqFeat1"+q+", "+q+"OrReqFeat2"+q+", "+q+"OrReqFeat3"+q+", "+q+"OrReqFeat4"+q+", "+q+"REQSKILL"+q+", "+q+"REQSKILL2"+q+","
            +" "+q+"ReqSkillMinRanks"+q+", "+q+"ReqSkillMinRanks2"+q+" FROM "+q+"prc_cached2da_feat"+q+""
            +" WHERE ("+q+"FEAT"+q+" != '****')"
            +" AND (("+q+"PreReqEpic"+q+" = '****') OR ("+q+"PreReqEpic"+q+" = 0))"
            +" AND ("+q+"ALLCLASSESCANUSE"+q+" = 1)"
            +" AND ("+q+"MINATTACKBONUS"+q+" <= "+IntToString(nBAB)+")"
            +" AND ("+q+"MINSPELLLVL"+q+" <= "+IntToString(nCasterLevel)+")"
            +" AND ("+q+"MINSTR"+q+" <= "+IntToString(nStr)+")"
            +" AND ("+q+"MINDEX"+q+" <= "+IntToString(nDex)+")"
            +" AND ("+q+"MINCON"+q+" <= "+IntToString(nCon)+")"
            +" AND ("+q+"MININT"+q+" <= "+IntToString(nInt)+")"
            +" AND ("+q+"MINWIS"+q+" <= "+IntToString(nWis)+")"
            +" AND ("+q+"MINCHA"+q+" <= "+IntToString(nCha)+")"
            +" AND (("+q+"MaxLevel"+q+" = '****') OR ("+q+"MaxLevel"+q+" > "+IntToString(nLevel)+"))"
            +" AND ("+q+"MinFortSave"+q+" <= "+IntToString(nFortSave)+")"
            +" LIMIT "+IntToString(iMax)+" OFFSET "+IntToString(i);
    }

    PRC_SQLExecDirect(SQL);
    int bAtLeastOneResult;
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        bAtLeastOneResult = TRUE;
        int nRow = StringToInt(PRC_SQLGetData(1));
        int nStrRef = StringToInt(PRC_SQLGetData(2));
        string sName = GetStringByStrRef(nStrRef);
        string sPreReqFeat1 = PRC_SQLGetData(3);
        string sPreReqFeat2 = PRC_SQLGetData(4);
        string sOrReqFeat0 = PRC_SQLGetData(5);
        string sOrReqFeat1 = PRC_SQLGetData(6);
        string sOrReqFeat2 = PRC_SQLGetData(7);
        string sOrReqFeat3 = PRC_SQLGetData(8);
        string sOrReqFeat4 = PRC_SQLGetData(9);
        string sReqSkill = PRC_SQLGetData(10);
        string sReqSkill2 = PRC_SQLGetData(11);
        string sReqSkillRanks = PRC_SQLGetData(12);
        string sReqSkillRanks2 = PRC_SQLGetData(13);
//PrintString(sName);
        //enforcement testing
        if(sName == "" || sName == "Bad Strref")
        {
        }
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD)
            && nRow == FEAT_BLOOD_OF_THE_WARLORD
            && nRace != RACIAL_TYPE_ORC
            && nRace != RACIAL_TYPE_GRAYORC
            && nRace != RACIAL_TYPE_HALFORC
            && nRace != RACIAL_TYPE_QD_HALFORC
            && nRace != RACIAL_TYPE_TANARUKK
            && nRace != RACIAL_TYPE_OROG)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT)
            && nRow == FEAT_NIMBUSLIGHT
            && nMoral < 70)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE)
            && nRow == FEAT_HOLYRADIANCE
            && nMoral < 70)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN)
            && nRow == FEAT_SERVHEAVEN
            && nMoral < 70)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW)
            && nRow == FEAT_SAC_VOW
            && nMoral < 70)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED)
            && nRow == FEAT_VOW_OBED
            && (nMoral < 70 || nOrder < 70))
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON)
            && nRow == FEAT_THRALL_TO_DEMON
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS)
            && nRow == FEAT_DISCIPLE_OF_DARKNESS
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED)
            && nRow == FEAT_LICHLOVED
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS)
            && (nRow == FEAT_EB_ARM
                || nRow == FEAT_EB_CHEST
                || nRow == FEAT_EB_HAND
                || nRow == FEAT_EB_NECK
                || nRow == FEAT_EB_HEAD)
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM)
            && nRow == FEAT_VILE_WILL_DEFORM
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE)
            && nRow == FEAT_VILE_DEFORM_OBESE
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT)
            && nRow == FEAT_VILE_DEFORM_GAUNT
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_LOLTHS_MEAT)
            && nRow == 2441 //lolths meat
            && nRace != 163
            && nRace != 164)
            sName = "";
        else if(sPreReqFeat1 != "****")
        {
            int bReturn = FALSE;
            for(j=0;j<array_get_size(oPC, "Feats"); j++)
            {
                int nFeatID = array_get_int(oPC, "Feats", j);
                if(nFeatID == StringToInt(sPreReqFeat1))
                    bReturn = TRUE;
            }
            for(j=1;j<nLevel; j++)
            {
                int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nFeatID == StringToInt(sPreReqFeat1))
                    bReturn = TRUE;
            }
            if(bReturn == FALSE)
                sName = "";
        }
        else if(sPreReqFeat2 != "****")
        {
            int bReturn = FALSE;
            for(j=0;j<array_get_size(oPC, "Feats"); j++)
            {
                int nFeatID = array_get_int(oPC, "Feats", j);
                if(nFeatID == StringToInt(sPreReqFeat2))
                    bReturn = TRUE;
            }
            for(j=1;j<nLevel; j++)
            {
                int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nFeatID == StringToInt(sPreReqFeat2))
                    bReturn = TRUE;
            }
            if(bReturn == FALSE)
                sName = "";
        }
        else if(sOrReqFeat0 != "****"
                || sOrReqFeat1 != "****"
                || sOrReqFeat2 != "****"
                || sOrReqFeat3 != "****"
                || sOrReqFeat4 != "****")
        {
            int bReturn = FALSE;
            string sFeatTest = sOrReqFeat0;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            sFeatTest = sOrReqFeat1;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            sFeatTest = sOrReqFeat2;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            sFeatTest = sOrReqFeat3;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            sFeatTest = sOrReqFeat4;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            if(bReturn == FALSE)
                sName = "";
        }
        else if(sReqSkill != "****")
        {
            int nSkillValue = GetLocalInt(oPC, "Skill"+sReqSkill);
            if((sReqSkillRanks == "****" && nSkillValue)
                || nSkillValue >= StringToInt(sReqSkillRanks))
            {
            }
            else
                sName = "";
        }
        else if(sReqSkill2 != "****")
        {
            int nSkillValue = GetLocalInt(oPC, "Skill"+sReqSkill2);
            if((sReqSkillRanks2 == "****" && nSkillValue)
                || nSkillValue >= StringToInt(sReqSkillRanks2))
            {
            }
            else
                sName = "";
        }

        if(sName != "")
        {   //Test its not already been given
            for(j=1;j<=array_get_size(oPC, "Feats"); j++)
            {
                int nTestFeatID = array_get_int(oPC, "Feats", j);
                if(nTestFeatID == nRow)
                    sName = "";
            }
        }
        if(sName != "")
        {   //test its not been taken as a racial bonus feat
            for(j=1;j<nLevel; j++)
            {
                int nTestFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nTestFeatID == nRow)
                    sName = "";
            }
        }
        if(sName != "")
        {   //test its not already on the list
            for(j=0;j<array_get_size(OBJECT_SELF, "ChoiceValue");j++)
            {
                if(array_get_int(OBJECT_SELF, "ChoiceValue", j) == nRow)
                    sName = "";
            }
        }
        DoDebug(sName);

        if(sName != "")
        {
            AddChoice(sName, nRow);
        }
    }
    int n2daLimit;
    if(nClassFeatStage)
        n2daLimit = GetPRCSwitch(FILE_END_CLASS_FEAT);
    else
        n2daLimit = GetPRCSwitch(FILE_END_FEAT);

    if(!bAtLeastOneResult)
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        if(nClassFeatStage)
        {
            DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
            FloatingTextStringOnCreature("Done all feats", OBJECT_SELF, FALSE);
            return;
        }
        else
        {
            nClassFeatStage = TRUE;
            FloatingTextStringOnCreature("Done general feats", OBJECT_SELF, FALSE);
        }
    }

    i += iMax;
    SetLocalInt(OBJECT_SELF, "i", i);
    /*
    if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
    {
        int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(n2daLimit));
        FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "Percentage",1);
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
    }*/

    DelayCommand(0.01, FeatLoop(nClassFeatStage));
}

int IsInWizList(int nSpell, int nLevel)
{
    int i;
    string sLevel = IntToString(nLevel);
    for (i=2;i<array_get_size(OBJECT_SELF, "SpellLvl"+sLevel);i++)
    {
        if(nSpell == array_get_int(OBJECT_SELF,"SpellLvl"+sLevel,i))
            return TRUE;
    }
    return FALSE;
}

void SpellLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    string sClassCol;
    int nClass = GetLocalInt(OBJECT_SELF, "Class");
    string SQL;

    string q = PRC_SQLGetTick();

    //get spellschool
    int nSchool = GetLocalInt(OBJECT_SELF, "School");
    //get opposition school
    string sOpposition = Get2DACache("spellschools", "Letter", StringToInt(Get2DACache("spellschools", "Opposition", nSchool)));
    int bEnd = TRUE;
    if(i==0 && nClass == CLASS_TYPE_WIZARD)
    {
        //add all cantrips
        array_create(OBJECT_SELF, "SpellLvl0");
        SQL = "SELECT "+q+"rowid"+q+" FROM "+q+"prc_cached2da_spells"+q+" WHERE ("+q+"Wiz_Sorc"+q+" = 0) AND ("+q+"School"+q+" != '"+sOpposition+"')";
        PRC_SQLExecDirect(SQL);
        while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
        {
            bEnd = FALSE;
            int nRow = StringToInt(PRC_SQLGetData(1));
            array_set_int(OBJECT_SELF, "SpellLvl0",
                array_get_size(OBJECT_SELF, "SpellLvl0"),nRow);
        }
    }

    int nSpellLevel = GetLocalInt(OBJECT_SELF, "CurrentSpellLevel");
    switch(nClass)
    {
        case CLASS_TYPE_WIZARD:
            nSpellLevel = 1;
            SQL = "SELECT "+q+"rowid"+q+", "+q+"Name"+q+" FROM "+q+"prc_cached2da_spells"+q+" WHERE ("+q+"Wiz_Sorc"+q+" = 1) AND ("+q+"School"+q+" != '"+sOpposition+"') LIMIT 100 OFFSET "+IntToString(i);
            break;
        case CLASS_TYPE_SORCERER:
            SQL = "SELECT "+q+"rowid"+q+", "+q+"Name"+q+" FROM "+q+"prc_cached2da_spells"+q+" WHERE ("+q+"Wiz_Sorc"+q+" = "+IntToString(nSpellLevel)+") LIMIT 100 OFFSET "+IntToString(i);
            break;
        case CLASS_TYPE_BARD:
            SQL = "SELECT "+q+"rowid"+q+", "+q+"Name"+q+" FROM "+q+"prc_cached2da_spells"+q+" WHERE ("+q+"Bard"+q+" = "+IntToString(nSpellLevel)+") LIMIT 100 OFFSET "+IntToString(i);
            break;
    }
    PRC_SQLExecDirect(SQL);
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        bEnd = FALSE;
        int nStrRef = StringToInt(PRC_SQLGetData(2));
        string sName = GetStringByStrRef(nStrRef);
        int nRow = StringToInt(PRC_SQLGetData(1));
        if(IsInWizList(nRow, nSpellLevel))
            sName = "";
        if(sName != "")
        {
            sName = "Level "+IntToString(nSpellLevel)+" : "+sName;
            AddChoice(sName, nRow);
        }
    }

    if(bEnd)
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }

    i += 100;
    SetLocalInt(OBJECT_SELF, "i", i);
    /*
    if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
    {
        int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(SPELLS_2DA_END));
        FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "Percentage",1);
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
    }*/

    DelayCommand(0.01, SpellLoop());
}


void BonusFeatLoop()
{
    int iMax = 5;

    //get some stored data
    object oPC = OBJECT_SELF;
    int nStr = GetLocalInt(oPC, "Str");
    int nDex = GetLocalInt(oPC, "Dex");
    int nCon = GetLocalInt(oPC, "Con");
    int nInt = GetLocalInt(oPC, "Int");
    int nWis = GetLocalInt(oPC, "Wis");
    int nCha = GetLocalInt(oPC, "Cha");
    int nRace = GetLocalInt(oPC, "Race");
    int nLevel = GetLocalInt(oPC, "Level");
    int nOrder = GetLocalInt(oPC, "LawfulChaotic");
    int nMoral = GetLocalInt(oPC, "GoodEvil");
    //add racial ability alterations
    nStr += StringToInt(Get2DACache("racialypes", "StrAdjust", nRace));
    nDex += StringToInt(Get2DACache("racialypes", "DexAdjust", nRace));
    nCon += StringToInt(Get2DACache("racialypes", "ConAdjust", nRace));
    nInt += StringToInt(Get2DACache("racialypes", "IntAdjust", nRace));
    nWis += StringToInt(Get2DACache("racialypes", "WisAdjust", nRace));
    nCha += StringToInt(Get2DACache("racialypes", "ChaAdjust", nRace));
    int j;
    for(j=1;j<=nLevel;j++)
    {
        //ability
        if(j == 3 || j == 7 || j == 11 || j == 15
                || j == 19 || j == 23 || j == 27 || j == 31
                || j == 13 || j == 39)
        {
            int nAbil = GetLocalInt(OBJECT_SELF, "RaceLevel"+IntToString(j)+"Ability");
            switch(nAbil)
            {
                case ABILITY_STRENGTH:      nStr++;     break;
                case ABILITY_DEXTERITY:     nDex++;     break;
                case ABILITY_CONSTITUTION:  nCon++;     break;
                case ABILITY_INTELLIGENCE:  nInt++;     break;
                case ABILITY_WISDOM:        nWis++;     break;
                case ABILITY_CHARISMA:      nCha++;     break;
            }
        }
    }
    int nClass = GetLocalInt(oPC, "Class");
    int nSex = GetLocalInt(oPC, "Gender");
    int nBAB;
    for(j=0;j<=nLevel;j++)
    {
        nBAB += StringToInt(Get2DACache(Get2DACache("classes", "AttackBonusTable",nClass),"BAB",j));
    }
    int nCasterLevel;
    if(nClass == CLASS_TYPE_WIZARD
        || nClass == CLASS_TYPE_SORCERER
        || nClass == CLASS_TYPE_BARD
        || nClass == CLASS_TYPE_CLERIC
        || nClass == CLASS_TYPE_DRUID)
        nCasterLevel = 1;
    int nFortSave;
    for(j=0;j<=nLevel;j++)
    {
        nFortSave = StringToInt(Get2DACache(Get2DACache("classes","SavingThrowTable" , nClass), "FortSave", nLevel));
    }
    string sFeatList = Get2DACache("classes", "FeatsTable", nClass);
    sFeatList = GetStringLowerCase(sFeatList);

    string q = PRC_SQLGetTick();
    int i = GetLocalInt(OBJECT_SELF, "i");
    string SQL;
        SQL = "SELECT "+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"FEAT"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"PREREQFEAT1"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"PREREQFEAT2"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat0"+q+","
            +" "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat1"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat2"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat3"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"OrReqFeat4"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"REQSKILL"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"REQSKILL2"+q+","
            +" "+q+"prc_cached2da_feat"+q+"."+q+"ReqSkillMinRanks"+q+", "+q+"prc_cached2da_feat"+q+"."+q+"ReqSkillMinRanks2"+q+""
            +" FROM "+q+"prc_cached2da_cls_feat"+q+" INNER JOIN "+q+"prc_cached2da_feat"+q+""
            +" WHERE ("+q+"FEAT"+q+" != '****')"
            +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"file"+q+" = '"+sFeatList+"')"
            +" AND (("+q+"prc_cached2da_cls_feat"+q+"."+q+"List"+q+" = 2) OR ("+q+"prc_cached2da_cls_feat"+q+"."+q+"List"+q+" = 1))"
            +" AND (("+q+"PreReqEpic"+q+" = '****') OR ("+q+"PreReqEpic"+q+" = 0))"
            +" AND (("+q+"ALLCLASSESCANUSE"+q+" = 0) OR ("+q+"ALLCLASSESCANUSE"+q+" = '****'))"
            +" AND (("+q+"MINATTACKBONUS"+q+" = '****') OR ("+q+"MINATTACKBONUS"+q+" <= "+IntToString(nBAB)+"))"
            +" AND (("+q+"MINSPELLLVL"+q+" = '****') OR ("+q+"MINSPELLLVL"+q+" <= "+IntToString(nCasterLevel)+"))"
            +" AND (("+q+"MINSTR"+q+" = '****') OR ("+q+"MINSTR"+q+" <= "+IntToString(nStr)+"))"
            +" AND (("+q+"MINDEX"+q+" = '****') OR ("+q+"MINDEX"+q+" <= "+IntToString(nDex)+"))"
            +" AND (("+q+"MINCON"+q+" = '****') OR ("+q+"MINCON"+q+" <= "+IntToString(nCon)+"))"
            +" AND (("+q+"MININT"+q+" = '****') OR ("+q+"MININT"+q+" <= "+IntToString(nInt)+"))"
            +" AND (("+q+"MINWIS"+q+" = '****') OR ("+q+"MINWIS"+q+" <= "+IntToString(nWis)+"))"
            +" AND (("+q+"MINCHA"+q+" = '****') OR ("+q+"MINCHA"+q+" <= "+IntToString(nCha)+"))"
            +" AND (("+q+"MaxLevel"+q+" = '****') OR ("+q+"MaxLevel"+q+" > "+IntToString(nLevel)+"))"
            +" AND (("+q+"MinFortSave"+q+" = '****') OR ("+q+"MinFortSave"+q+" <= "+IntToString(nFortSave)+"))"
            +" AND ("+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+" != '****')"
            +" AND ("+q+"prc_cached2da_feat"+q+"."+q+"rowid"+q+" = "+q+"prc_cached2da_cls_feat"+q+"."+q+"FeatIndex"+q+")"
            +" LIMIT "+IntToString(iMax)+" OFFSET "+IntToString(i);

    PRC_SQLExecDirect(SQL);
    int bAtLeastOneResult;
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        bAtLeastOneResult = TRUE;
        int nRow = StringToInt(PRC_SQLGetData(1));
        int nStrRef = StringToInt(PRC_SQLGetData(2));
        string sName = GetStringByStrRef(nStrRef);
        string sPreReqFeat1 = PRC_SQLGetData(3);
        string sPreReqFeat2 = PRC_SQLGetData(4);
        string sOrReqFeat0 = PRC_SQLGetData(5);
        string sOrReqFeat1 = PRC_SQLGetData(6);
        string sOrReqFeat2 = PRC_SQLGetData(7);
        string sOrReqFeat3 = PRC_SQLGetData(8);
        string sOrReqFeat4 = PRC_SQLGetData(9);
        string sReqSkill = PRC_SQLGetData(10);
        string sReqSkill2 = PRC_SQLGetData(11);
        string sReqSkillRanks = PRC_SQLGetData(12);
        string sReqSkillRanks2 = PRC_SQLGetData(13);
        PrintString(sName);
        //enforcement testing
        if(sName == "" || sName == "Bad Strref")
        {
        }
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD)
            && nRow == FEAT_BLOOD_OF_THE_WARLORD
            && nRace != RACIAL_TYPE_ORC
            && nRace != RACIAL_TYPE_GRAYORC
            && nRace != RACIAL_TYPE_HALFORC
            && nRace != RACIAL_TYPE_QD_HALFORC
            && nRace != RACIAL_TYPE_TANARUKK
            && nRace != RACIAL_TYPE_OROG)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT)
            && nRow == FEAT_NIMBUSLIGHT
            && nMoral < 70)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE)
            && nRow == FEAT_HOLYRADIANCE
            && nMoral < 70)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN)
            && nRow == FEAT_SERVHEAVEN
            && nMoral < 70)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW)
            && nRow == FEAT_SAC_VOW
            && nMoral < 70)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED)
            && nRow == FEAT_VOW_OBED
            && (nMoral < 70 || nOrder < 70))
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON)
            && nRow == FEAT_THRALL_TO_DEMON
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS)
            && nRow == FEAT_DISCIPLE_OF_DARKNESS
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED)
            && nRow == FEAT_LICHLOVED
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS)
            && (nRow == FEAT_EB_ARM
                || nRow == FEAT_EB_CHEST
                || nRow == FEAT_EB_HAND
                || nRow == FEAT_EB_HEAD)
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM)
            && nRow == FEAT_VILE_WILL_DEFORM
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE)
            && nRow == FEAT_VILE_DEFORM_OBESE
            && nMoral > 20)
            sName = "";
        else if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT)
            && nRow == FEAT_VILE_DEFORM_GAUNT
            && nMoral > 20)
            sName = "";
        else if(sPreReqFeat1 != "****")
        {
            int bReturn = FALSE;
            for(j=0;j<array_get_size(oPC, "Feats"); j++)
            {
                int nFeatID = array_get_int(oPC, "Feats", j);
                if(nFeatID == StringToInt(sPreReqFeat1))
                    bReturn = TRUE;
            }
            for(j=1;j<nLevel; j++)
            {
                int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nFeatID == StringToInt(sPreReqFeat1))
                    bReturn = TRUE;
            }
            if(bReturn == FALSE)
                sName = "";
        }
        else if(sPreReqFeat2 != "****")
        {
            int bReturn = FALSE;
            for(j=0;j<array_get_size(oPC, "Feats"); j++)
            {
                int nFeatID = array_get_int(oPC, "Feats", j);
                if(nFeatID == StringToInt(sPreReqFeat2))
                    bReturn = TRUE;
            }
            for(j=1;j<nLevel; j++)
            {
                int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nFeatID == StringToInt(sPreReqFeat2))
                    bReturn = TRUE;
            }
            if(bReturn == FALSE)
                sName = "";
        }
        else if(sOrReqFeat0 != "****"
                || sOrReqFeat1 != "****"
                || sOrReqFeat2 != "****"
                || sOrReqFeat3 != "****"
                || sOrReqFeat4 != "****")
        {
            int bReturn = FALSE;
            string sFeatTest = sOrReqFeat0;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            sFeatTest = sOrReqFeat1;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            sFeatTest = sOrReqFeat2;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            sFeatTest = sOrReqFeat3;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            sFeatTest = sOrReqFeat4;
            if(sFeatTest != "****")
            {
                for(j=0;j<array_get_size(oPC, "Feats"); j++)
                {
                    int nFeatID = array_get_int(oPC, "Feats", j);
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
                for(j=1;j<nLevel; j++)
                {
                    int nFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                    if(nFeatID == StringToInt(sFeatTest))
                        bReturn = TRUE;
                }
            }
            if(bReturn == FALSE)
                sName = "";
        }
        else if(sReqSkill != "****")
        {
            int nSkillValue = GetLocalInt(oPC, "Skill"+sReqSkill);
            if((sReqSkillRanks == "****" && nSkillValue)
                || nSkillValue >= StringToInt(sReqSkillRanks))
            {
            }
            else
                sName = "";
        }
        else if(sReqSkill2 != "****")
        {
            int nSkillValue = GetLocalInt(oPC, "Skill"+sReqSkill2);
            if((sReqSkillRanks2 == "****" && nSkillValue)
                || nSkillValue >= StringToInt(sReqSkillRanks2))
            {
            }
            else
                sName = "";
        }

        if(sName != "")
        {   //Test its not already been given
            for(j=1;j<=array_get_size(oPC, "Feats"); j++)
            {
                int nTestFeatID = array_get_int(oPC, "Feats", j);
                if(nTestFeatID == nRow)
                    sName = "";
            }
        }
        if(sName != "")
        {   //test its not been taken as a racial bonus feat
            for(j=1;j<nLevel; j++)
            {
                int nTestFeatID = GetLocalInt(oPC, "RaceLevel"+IntToString(j)+"Feat");
                if(nTestFeatID == nRow)
                    sName = "";
            }
        }
        if(sName != "")
        {   //test its not already on the list
            for(j=0;j<array_get_size(OBJECT_SELF, "ChoiceValue");j++)
            {
                if(array_get_int(OBJECT_SELF, "ChoiceValue", j) == nRow)
                    sName = "";
            }
        }
        //PrintString(sName);

        if(sName != "")
        {
            AddChoice(sName, nRow);
        }
    }
    int n2daLimit;
    n2daLimit = GetPRCSwitch(FILE_END_CLASS_FEAT);

    if(!bAtLeastOneResult)
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }

    i += iMax;
    SetLocalInt(OBJECT_SELF, "i", i);
    /*
    if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
    {
        int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(n2daLimit));
        FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "Percentage",1);
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
    }*/

    DelayCommand(0.01, BonusFeatLoop());
}


void RaceLoop()
{

    if(GetLocalInt(OBJECT_SELF, "DynConv_Waiting") == FALSE)
        return;
    string q = PRC_SQLGetTick();
    int nReali = GetLocalInt(OBJECT_SELF, "i");
    string SQL = "SELECT "+q+"rowid"+q+", "+q+"Name"+q+" FROM "+q+"prc_cached2da_racialtypes"+q+" WHERE ("+q+"PlayerRace"+q+" = 1) LIMIT 25 OFFSET "+IntToString(nReali);
    PRC_SQLExecDirect(SQL);
    int bAtLeastOneResult;
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        bAtLeastOneResult = TRUE;
        int nRace = StringToInt(PRC_SQLGetData(1));
        int bIsTakeable = TRUE;

        if(nRace == RACIAL_TYPE_DROW_FEMALE
            && GetLocalInt(OBJECT_SELF, "Gender") == GENDER_MALE
            && GetPRCSwitch(PRC_CONVOCC_DROW_ENFORCE_GENDER))
            bIsTakeable = FALSE;
        if(nRace == RACIAL_TYPE_DROW_MALE
            && GetLocalInt(OBJECT_SELF, "Gender") == GENDER_FEMALE
            && GetPRCSwitch(PRC_CONVOCC_DROW_ENFORCE_GENDER))
            bIsTakeable = FALSE;

        if(bIsTakeable)
        {
            string sName = GetStringByStrRef(StringToInt(PRC_SQLGetData(2)));
            AddChoice(sName, nRace);
        }
    }

    if(!bAtLeastOneResult)
    {
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "i");
        return;
    }
    SetLocalInt(OBJECT_SELF, "i", nReali+25);
    DelayCommand(0.01, RaceLoop());
}

void DoClassFeat(string sClassFeatTable, int i=0)
{
    if(i<GetPRCSwitch(FILE_END_CLASS_FEAT))
    {
        if(Get2DACache(sClassFeatTable, "FeatIndex", i) != ""
            && Get2DACache(sClassFeatTable, "List", i) == "3"
            && Get2DACache(sClassFeatTable, "GrantedOnLevel", i) == "1")
        {
            array_set_int(OBJECT_SELF, "Feats", array_get_size(OBJECT_SELF, "Feats"),
                StringToInt(Get2DACache(sClassFeatTable, "FeatIndex", i)));
        }
        i++;
        DelayCommand(0.1, DoClassFeat(sClassFeatTable, i));
    }
}



void AppearanceLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    string q = PRC_SQLGetTick();
    string SQL = "SELECT "+q+"rowid"+q+", "+q+"STRING_REF"+q+" FROM "+q+"prc_cached2da_appearance"+q+" WHERE ("+q+"STRING_REF"+q+" != '****') LIMIT 100 OFFSET "+IntToString(i);
    PRC_SQLExecDirect(SQL);
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        int nStrRef = StringToInt(PRC_SQLGetData(2));
        string sName = GetStringByStrRef(nStrRef);
        int nRow = StringToInt(PRC_SQLGetData(1));
        AddChoice(sName, nRow);
    }

    if(i > GetPRCSwitch(FILE_END_APPEARANCE))
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }

    i += 100;
    SetLocalInt(OBJECT_SELF, "i", i);
    /*if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
    {
        int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(GetPRCSwitch(FILE_END_APPEARANCE)));
        FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "Percentage",1);
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
    }*/

    DelayCommand(0.01, AppearanceLoop());
}


void SoundsetLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    string q = PRC_SQLGetTick();
    string SQL = "SELECT "+q+"rowid"+q+", "+q+"STRREF"+q+", "+q+"TYPE"+q+", "+q+"GENDER"+q+" FROM "+q+"prc_cached2da_soundset"+q+" WHERE ("+q+"RESREF"+q+" != '****') LIMIT 100 OFFSET "+IntToString(i);
    PRC_SQLExecDirect(SQL);
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        int nRow = StringToInt(PRC_SQLGetData(1));
        int nStrRef = StringToInt(PRC_SQLGetData(2));
        string sName = GetStringByStrRef(nStrRef);
        if(GetPRCSwitch(PRC_CONVOCC_ONLY_PLAYER_VOICESETS)
            && PRC_SQLGetData(3) != "0")
            sName = "";
        if(GetPRCSwitch(PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX)
            && StringToInt(PRC_SQLGetData(4)) != GetLocalInt(OBJECT_SELF, "Gender"))
            sName = "";
        if(sName != "")
        {
            AddChoice(sName, nRow);
        }
    }

    if(i > GetPRCSwitch(FILE_END_SOUNDSET))
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }

    i += 100;
    SetLocalInt(OBJECT_SELF, "i", i);
    /*if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
    {
        int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(GetPRCSwitch(FILE_END_SOUNDSET)));
        FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "Percentage",1);
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
    }*/

    DelayCommand(0.01, SoundsetLoop());
}

void PortraitLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    string q = PRC_SQLGetTick();
    string SQL = "SELECT "+q+"rowid"+q+", "+q+"BaseResRef"+q+", "+q+"Race"+q+", "+q+"SEX"+q+" FROM "+q+"prc_cached2da_portraits"+q+" WHERE ("+q+"InanimateType"+q+" = '****') AND ("+q+"BaseResRef"+q+" != '****') LIMIT 100 OFFSET "+IntToString(i);
    PRC_SQLExecDirect(SQL);
    while(PRC_SQLFetch() == PRC_SQL_SUCCESS)
    {
        int nRow = StringToInt(PRC_SQLGetData(1));
        string sName = PRC_SQLGetData(2);
        int nPortGender = StringToInt(PRC_SQLGetData(4));
        int nPortRace = StringToInt(PRC_SQLGetData(3));
        if(GetPRCSwitch(PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX)
            && nPortGender != GetLocalInt(OBJECT_SELF, "Gender"))
            sName = "";
        if(sName != "")
        {
            AddChoice(sName, nRow);
        }
    }

    if(i > GetPRCSwitch(FILE_END_PORTRAITS))
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }

    i += 100;
    SetLocalInt(OBJECT_SELF, "i", i);
    /*if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
    {
        int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(GetPRCSwitch(FILE_END_PORTRAITS)));
        FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
        SetLocalInt(OBJECT_SELF, "Percentage",1);
        DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
    }*/

    DelayCommand(0.01, PortraitLoop());
}

void WingLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(i > GetPRCSwitch(FILE_END_WINGS))
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }
    else
    {
        string sName = Get2DACache("wingmodel", "Label", i);
        if(sName != "")
        {
            AddChoice(sName, i);
        }
        i++;
        SetLocalInt(OBJECT_SELF, "i", i);
        if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(GetPRCSwitch(FILE_END_WINGS)));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
        }
        DelayCommand(0.01, WingLoop());
    }
}

void TailLoop()
{
    int i = GetLocalInt(OBJECT_SELF, "i");
    if(i > GetPRCSwitch(FILE_END_TAILS))
    {
        DeleteLocalInt(OBJECT_SELF, "i");
        DeleteLocalInt(OBJECT_SELF, "DynConv_Waiting");
        DeleteLocalInt(OBJECT_SELF, "Percentage");
        FloatingTextStringOnCreature("Done", OBJECT_SELF, FALSE);
        return;
    }
    else
    {
        string sName = Get2DACache("tailmodel", "Label", i);
        if(sName != "")
        {
            AddChoice(sName, i);
        }
        i++;
        SetLocalInt(OBJECT_SELF, "i", i);
        if(GetLocalInt(OBJECT_SELF, "Percentage") == 0)
        {
            int nPercentage = FloatToInt((IntToFloat(i)*100.0)/IntToFloat(GetPRCSwitch(FILE_END_TAILS)));
            FloatingTextStringOnCreature(IntToString(nPercentage)+"%", OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "Percentage",1);
            DelayCommand(1.0, DeleteLocalInt(OBJECT_SELF, "Percentage"));
        }
        DelayCommand(0.01, TailLoop());
    }
}


