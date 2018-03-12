/*

    This file is used for lookup functions for psionics and newspellbooks
    It is supposed to reduce the need for large loops that may result in
    TMI errors.
    It does this by creating arrays in advance and the using those as direct
    lookups.
*/

//nClass is the class to do this for
//nMin is the row to start at
//sSourceColumn is the column you want to lookup by
//sDestComumn is the column you want returned
//sVarNameBase is the root of the variables and tag of token
//nLoopSize is the number of rows per call
void MakeLookupLoop(int nClass, int nMin, int nMax, string sSourceColumn, 
    string sDestColumn, string sVarNameBase, int nLoopSize = 100);

void MakeSpellbookLevelLoop(int nClass, int nMin, int nMax, string sVarNameBase, 
    string sColumnName, string sColumnValue, int nLoopSize = 100);
    
//this returns the real SpellID of "wrapper" spells cast by psionic or the new spellbooks
int GetPowerFromSpellID(int nSpellID);

//this retuns the featID of the class-specific feat for a spellID
//useful for psionics GetHasPower function
int GetClassFeatFromPower(int nPowerID, int nClass);

/**
 * Determines the name of the 2da file that defines the number of powers
 * known, maximum level of powers known and number of power points
 * at each level of the given class.
 *
 * @param nClass CLASS_TYPE_* of the class to determine the psionics 2da name of
 * @return       The name of the given class's psionics 2da
 */
string GetPsionicFileName(int nClass);

/**
 * Determines the name of the 2da file that lists the powers
 * on the given class's power list.
 *
 * @param nClass CLASS_TYPE_* of the class to determine the power list 2da name of
 * @return       The name of the given class's power list 2da
 */
string GetPsiBookFileName(int nClass);


#include "inc_utility"
#include "prc_class_const"

void MakeLookupLoopMaster()
{
    //now the loops
    DelayCommand(1.0, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(1.2, MakeLookupLoop(CLASS_TYPE_PSION,            0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_PSION)));
    DelayCommand(1.4, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(1.6, MakeLookupLoop(CLASS_TYPE_PSYWAR,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_PSYWAR)));
    DelayCommand(1.8, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.0, MakeLookupLoop(CLASS_TYPE_WILDER,           0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_WILDER)));
    DelayCommand(2.2, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.4, MakeLookupLoop(CLASS_TYPE_FIST_OF_ZUOKEN,   0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_FIST_OF_ZUOKEN)));
    DelayCommand(2.6, MakeLookupLoop(CLASS_TYPE_WARMIND,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.8, MakeLookupLoop(CLASS_TYPE_WARMIND,          0, GetPRCSwitch(FILE_END_CLASS_POWER), "RealSpellID", "FeatID",  "GetClassFeatFromPower_"+IntToString(CLASS_TYPE_WARMIND)));
    //add new psionic classes here
    //also add them later too

    //new spellbook lookups
    DelayCommand(2.6, MakeLookupLoop(CLASS_TYPE_BLACKGUARD,          0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.7, MakeLookupLoop(CLASS_TYPE_ANTI_PALADIN,        0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.8, MakeLookupLoop(CLASS_TYPE_SOLDIER_OF_LIGHT,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(2.9, MakeLookupLoop(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, 0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.0, MakeLookupLoop(CLASS_TYPE_KNIGHT_CHALICE,      0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.1, MakeLookupLoop(CLASS_TYPE_VIGILANT,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.2, MakeLookupLoop(CLASS_TYPE_VASSAL,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.3, MakeLookupLoop(CLASS_TYPE_OCULAR,              0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.4, MakeLookupLoop(CLASS_TYPE_ASSASSIN,            0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellID", "RealSpellID", "GetPowerFromSpellID"));
    DelayCommand(3.5, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "1"));
    DelayCommand(3.6, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "2"));
    DelayCommand(3.7, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "3"));
    DelayCommand(3.8, MakeSpellbookLevelLoop(CLASS_TYPE_ASSASSIN,    0, GetPRCSwitch(FILE_END_CLASS_SPELLBOOK) , "SpellLvl", "Level", "4"));
}

void MakeSpellbookLevelLoop(int nClass, int nMin, int nMax, string sVarNameBase, 
    string sColumnName, string sColumnValue, int nLoopSize = 100)
{
    string sFile;
    if(nClass == CLASS_TYPE_PSION          ||
       nClass == CLASS_TYPE_PSYWAR         ||
       nClass == CLASS_TYPE_WILDER         ||
       nClass == CLASS_TYPE_FIST_OF_ZUOKEN ||
       nClass == CLASS_TYPE_WARMIND
    //add new psionic classes here
        )
        sFile = GetPsiBookFileName(nClass);
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
    }    
    
    //get the token to store it on
    //this is piggybacked into 2da caching
    string sTag = ""+sVarNameBase+"_"+IntToString(nClass)+"_"+sColumnName+"_"+sColumnValue;
    object oWP = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oWP))
    {
        object oChest = GetObjectByTag("Bioware2DACache");
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB    
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
             GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
        }
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB    
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
                GetStartingLocation(), FALSE, "Bioware2DACache");
        }
        oWP = CreateObject(OBJECT_TYPE_ITEM, "hidetoken", GetLocation(oChest), FALSE, sTag);
        DestroyObject(oWP);
        oWP = CopyObject(oWP, GetLocation(oChest), oChest, sTag);
    }
    if(!GetIsObjectValid(oWP))
    {
        DoDebug("Problem creating token for "+sTag);
        return;
    }  
    
    if(nMin == 0)
        array_create(oWP, sTag);  
    
    int i = nMin;
    for(i=nMin;i<nMin+nLoopSize;i++)
    {
        if(Get2DACache(sFile, sColumnName, i) == sColumnValue
            && Get2DACache(sFile, "ReqFeat", i) == "")
            array_set_int(oWP, sTag, array_get_size(oWP, sTag), i);    
    }
    if(i<nMax)
        DelayCommand(1.0, MakeSpellbookLevelLoop(nClass, i, nMax, sVarNameBase, sColumnName, sColumnValue, nLoopSize));

}

void MakeLookupLoop(int nClass, int nMin, int nMax, string sSourceColumn, 
    string sDestColumn, string sVarNameBase, int nLoopSize = 100)
{
    //get the token to store it on
    //this is piggybacked into 2da caching
    string sTag = "PRC_"+sVarNameBase;
    object oWP = GetObjectByTag(sTag);
    if(!GetIsObjectValid(oWP))
    {
        object oChest = GetObjectByTag("Bioware2DACache");
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB    
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
             GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
        }
        if(!GetIsObjectValid(oChest))
        {
            //has to be an object, placeables cant go through the DB    
            oChest = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
                GetStartingLocation(), FALSE, "Bioware2DACache");
        }
        oWP = CreateObject(OBJECT_TYPE_ITEM, "hidetoken", GetLocation(oChest), FALSE, sTag);
        DestroyObject(oWP);
        oWP = CopyObject(oWP, GetLocation(oChest), oChest, sTag);
    }
    if(!GetIsObjectValid(oWP))
    {
        DoDebug("Problem creating token for "+sTag);
        return;
    }

    string sFile;
    if(nClass == CLASS_TYPE_PSION          ||
       nClass == CLASS_TYPE_PSYWAR         ||
       nClass == CLASS_TYPE_WILDER         ||
       nClass == CLASS_TYPE_FIST_OF_ZUOKEN ||
       nClass == CLASS_TYPE_WARMIND
    //add new psionic classes here
        )
        sFile = GetPsiBookFileName(nClass);
    else
    {
        sFile = Get2DACache("classes", "FeatsTable", nClass);
        sFile = GetStringLeft(sFile, 4)+"spell"+GetStringRight(sFile, GetStringLength(sFile)-8);
    }    

    int i = nMin;
    for(i=nMin;i<nMin+nLoopSize;i++)
    {
        int nSpellID = StringToInt(Get2DACache(sFile, sSourceColumn, i));
        int nPower   = StringToInt(Get2DACache(sFile, sDestColumn,   i));
        if(nSpellID != 0 
            && nPower != 0)
        {   
            SetLocalInt(oWP, sTag+"_"+IntToString(nSpellID), nPower);
        }    
    }
    if(i<nMax)
        DelayCommand(1.0, MakeLookupLoop(nClass, i, nMax, sSourceColumn, sDestColumn, sVarNameBase, nLoopSize));
}

int GetPowerFromSpellID(int nSpellID)
{
    object oWP = GetObjectByTag("PRC_GetPowerFromSpellID");
    int nPower = GetLocalInt(oWP, "PRC_GetPowerFromSpellID_"+IntToString(nSpellID));
    if(nPower == 0)
        nPower = -1;
    return nPower;
}

int GetClassFeatFromPower(int nPowerID, int nClass)
{
    string sLabel = "PRC_GetClassFeatFromPower_"+IntToString(nClass);
    object oWP = GetObjectByTag(sLabel);
    int nPower = GetLocalInt(oWP, sLabel+"_"+IntToString(nPowerID));
    if(nPower == 0)
        nPower = -1;
    return nPower;
}

string GetPsionicFileName(int nClass)
{
    string sPsiFile = Get2DACache("classes", "FeatsTable", nClass);
    sPsiFile = GetStringLeft(sPsiFile, 4)+"psbk"+GetStringRight(sPsiFile, GetStringLength(sPsiFile)-8);
    return sPsiFile;
}

string GetPsiBookFileName(int nClass)
{
    string sPsiFile = Get2DACache("classes", "FeatsTable", nClass);
    sPsiFile = GetStringLeft(sPsiFile, 4)+"psipw"+GetStringRight(sPsiFile, GetStringLength(sPsiFile)-8);
    return sPsiFile;
}