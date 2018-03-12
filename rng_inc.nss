//::///////////////////////////////////////////////
//:: Name               rng_inc
//:: FileName           Random Name Generator
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A set of functions for randon name generation
    and replacements for biowares random number
    generator in scripts (taken from Syrsnein's
    work @ http://nwvault.ign.com/View.php?view=scripts.Detail&id=2931 )

    The random name generator needs 2 2da files
    rng_data.2da:
        MinLetters        Minimum number of letters
        MaxLetters        Maximum number of letters
        NameList          Name of the column in rng_lists.2da
    rng_names.2da:
        "default" column, plus others as in rng_data NameList
        Each column is a list of example names for that race to use
        New names are generated letter by letter, based on the relative
        abundance of the letters in the examples weighted by up to 4
        previous letters.
*/
//:://////////////////////////////////////////////
//:: Created By: Primogenitor
//:: Created On: 23/03/06
//:://////////////////////////////////////////////


// Generates a random name on a letter-by-letter basis
//
// sColumn is the column in rng_names.2da to base it on
//
// nMin is the minumum number of letters to use
//
// nMax is the maximum number of letters to use
//
// nDepth is the number of previous letters to base
// selection of the next letter on
//
//
// NOTE: Actual length is a linear distribution between nMin and nMax
//
string RNG_GetRandomName(string sColumn = "Natural", int nMin = 5, int nMax = 10, int nDepth = 2);

// Generates a random name on a letter-by-letter
//
// nRacialType is the row in rng_data.2da to use
//
// nDepth is the number of previous letters to base
// selection of the next letter on
//
string RNG_GetRandomNameByRace(int nRacialType = RACIAL_TYPE_INVALID, int nDepth = 2);

// Generates a random name on a letter-by-letter basis
//
// oObject is the racial type to use
//
// nDepth is the number of previous letters to base
// selection of the next letter on
//
string RNG_GetRandomNameForObject(object oObject, int nDepth = 2);

// This MUST be called before generating any names and will
// take several seconds to fully run
//
// sNameType should be the name of the column in rng_names.2da
// to use. If it is "", then the function will loop over
// rng_data.2da and process each rows reference
//
// nPos should be zero in the inital call, this function will
// call itself repeatedly untill all the list is done
//
// NOTE: This uses a lot of 2da reads, so it will cause lag.
//
void RNG_SetupNameList(string sNameType = "Natural", int nPos = 0);


#include "sy_inc_random"


//PRIVATE FUNCTION
object RNG_GetWaypointForColumn(string sNameType = "default")
{
    object oWP;
    oWP = GetWaypointByTag("RNG_WP_"+sNameType);
    if(!GetIsObjectValid(oWP))
        oWP = CreateObject(OBJECT_TYPE_WAYPOINT,
            "nw_waypoint001",
            GetStartingLocation(),
            FALSE,
            "RNG_WP_"+sNameType);
    if(!GetIsObjectValid(oWP))
        oWP = GetModule();
    return oWP;
}

//PRIVATE FUNCTION
void RNG_SetupNameListAddLetter(string sCurrLetter, string sVar, object oWP)
{
    //get the letter total
    int nLetterTotal = GetLocalInt(oWP, sVar+"_total");
    //add the letter to the array
    SetLocalString(oWP, sVar+"_"+IntToString(nLetterTotal), sCurrLetter);
    //increase the letter total
    nLetterTotal++;
    SetLocalInt(oWP, sVar+"_total", nLetterTotal);
}

//PRIVATE FUNCTION
string RNG_GetRandomLetter(string sNameType = "default", string sLastLetter = "",
    string sLast2Letter = "", string sLast3Letter = "", string sLast4Letter = "")
{
    object oWP = RNG_GetWaypointForColumn(sNameType);
    string sVar = "RNG_"+sNameType;
    if(sLastLetter != "")
        sVar += "_"+sLastLetter;
    if(sLast2Letter != "")
        sVar += "_"+sLast2Letter;
    if(sLast3Letter != "")
        sVar += "_"+sLast3Letter;
    if(sLast4Letter != "")
        sVar += "_"+sLast4Letter;
    int nTotal =GetLocalInt(oWP, sVar+"_total");
    //if none exist, retry with smaller combination
    if(!nTotal)
    {
        if(sLastLetter == "")
            return "";
        else if(sLast2Letter == "")
            return RNG_GetRandomLetter(sNameType);
        else if(sLast3Letter == "")
            return RNG_GetRandomLetter(sNameType, sLastLetter);
        else if(sLast4Letter == "")
            return RNG_GetRandomLetter(sNameType, sLastLetter, sLast2Letter);
        else
            return RNG_GetRandomLetter(sNameType, sLastLetter, sLast2Letter, sLast3Letter);
    }
    int nID= RandomI(nTotal);
    string sLetter= GetLocalString(oWP, sVar+"_"+IntToString(nID));
    return sLetter;
}

string RNG_GetRandomNameForObject(object oObject, int nDepth = 2)
{
    return RNG_GetRandomNameByRace(GetRacialType(oObject), nDepth);
}

string RNG_GetRandomName(string sColumn = "default", int nMin = 5, int nMax = 10, int nDepth = 2)
{
    if(sColumn == "")
        sColumn = "Natural";
    int nCount = (RandomI(nMax-nMin)+nMin);
    //sanity checks
    if(nCount < 1)
        nCount = 1;
    if(nCount > 25)
        nCount = 25;
    //add letters
    int i;
    string sNewLetter;
    string sOldLetter;
    string sOldLetter2;
    string sOldLetter3;
    string sOldLetter4;
    string sName;
    for(i=0;i<nCount;i++)
    {
        if(nDepth == 4)
            sNewLetter = RNG_GetRandomLetter(sColumn, sOldLetter, sOldLetter2, sOldLetter3, sOldLetter4);
        else if(nDepth == 3)
            sNewLetter = RNG_GetRandomLetter(sColumn, sOldLetter, sOldLetter2, sOldLetter3);
        else if(nDepth == 2)
            sNewLetter = RNG_GetRandomLetter(sColumn, sOldLetter, sOldLetter2);
        else if(nDepth == 1)
            sNewLetter = RNG_GetRandomLetter(sColumn, sOldLetter);
        else if(nDepth == 0)
            sNewLetter = RNG_GetRandomLetter(sColumn);
        sName += sNewLetter;
        sOldLetter4 = sOldLetter3;
        sOldLetter3 = sOldLetter2;
        sOldLetter2 = sOldLetter;
        sOldLetter = sNewLetter;
    }
    //capitalize first letter
    sName = GetStringLowerCase(sName);
    string sInitial = GetStringLeft(sName,1);
    sInitial = GetStringUpperCase(sInitial);
    sName = sInitial+GetStringRight(sName, GetStringLength(sName)-1);
    return sName;
}

string RNG_GetRandomNameByRace(int nRacialType = RACIAL_TYPE_INVALID, int nDepth = 2)
{
    //default to a random "normal" race name
    if(nRacialType == RACIAL_TYPE_INVALID)
        nRacialType = RandomI(7);
    //get the number of letters to use
    int nMin = StringToInt(Get2DAString("rng_data", "MinLetters", nRacialType));
    int nMax = StringToInt(Get2DAString("rng_data", "MaxLetters", nRacialType));
    //get the column to use
    string sColumn = Get2DAString("rng_data", "NameList", nRacialType);
    return RNG_GetRandomName(sColumn, nMin, nMax, nDepth);
}


void RNG_SetupNameList(string sNameType = "default", int nPos = 0)
{
    //if calling with no name type
    //then loop over the rng_data races
    if(sNameType == "")
    {
        int i;
        for(i=0;i<255;i++)
        {
            string sColumn = Get2DAString("rng_data", "NameList", i);
            if(sColumn == "")
                sColumn = "Natural";
            //make sure you only start it once
            if(!GetLocalInt(GetModule(), sColumn+"_started"))
            {
                SetLocalInt(GetModule(), sColumn+"_started", TRUE);
                DelayCommand(1.0, DeleteLocalInt(GetModule(), sColumn+"_started"));
                DelayCommand(0.0, RNG_SetupNameList(sColumn, 0));
            }
        }
        //dont do anything else
        return;
    }
    //do some WP creation/getting stuff here
    object oWP = RNG_GetWaypointForColumn(sNameType);
    //dont re-cache stuff accidentaly
    if(GetLocalInt(oWP, "RNG_"+sNameType+"_total")
        && nPos == 0)
        return;
    //loop over the rows
    int nRow;
    for(nRow = nPos; nRow < nPos+100; nRow++)
    {
        string sName = Get2DAString("rng_names", sNameType, nRow);
        //end of list, abort
        if(sName == "")
            return;
        //save time, only check the first 100
        if(nRow > 100)
            return;
        string sLast4Letter;
        string sLast3Letter;
        string sLast2Letter;
        string sLastLetter;
        string sCurrLetter;
        int nLetterID;
        //loop over all letters
        for(nLetterID = 0; nLetterID < GetStringLength(sName); nLetterID++)
        {
            string sVar;
            int nLetterTotal;
            //get the letter
            sCurrLetter = GetSubString(sName, nLetterID, 1);

            //do 0-letter lag
            //work out what the var name is
            sVar = "RNG_"+sNameType;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //do 1-letter lag
            //work out what the var name is
            sVar += "_"+sLastLetter;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //do 2-letter lag
            //work out what the var name is
            sVar += "_"+sLast2Letter;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //do 3-letter lag
            //work out what the var name is
            sVar += "_"+sLast3Letter;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //do 4-letter lag
            //work out what the var name is
            sVar += "_"+sLast4Letter;
            //add the letter
            DelayCommand(0.0, RNG_SetupNameListAddLetter(sCurrLetter, sVar, oWP));

            //move to next letter
            sLast4Letter = sLast3Letter;
            sLast3Letter = sLast2Letter;
            sLast2Letter = sLastLetter;
            sLastLetter = sCurrLetter;
        }
    }
    DelayCommand(0.0, RNG_SetupNameList(sNameType, nRow));
}
