//:://////////////////////////////////////////////
//:: Include File for Item Creation Feats
//:: prc_inc_craft
//:: Copyright (c) 2003 Gerald Leung.
//::
//:: Created By: Gerald Leung
//:: Created On: November 12, 2003
//:: Edited  By: Guido Imperiale
//:: Edited  On: March 1, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "nw_i0_generic"
#include "x2_inc_itemprop"
#include "inc_utility"
#include "prc_inc_spells"

//remove this placeholder when upgrading to PRC 2.3
int GetLevelByTypePsionicFeats(object oCreature)
{return 0;}


/****************************
 * CONSTANTS AND STRUCTURES *
 ****************************/

 // TLK entries

int STRREF_OFFSET = 0x01000000 + 47195;

int STRREF_DIVINE            = STRREF_OFFSET + 0;
int STRREF_ARCANE            = STRREF_OFFSET + 1;
int STRREF_PSIONIC           = STRREF_OFFSET + 2;
int STRREF_HELPER            = STRREF_OFFSET + 3;
int STRREF_OR                = STRREF_OFFSET + 4;
int STRREF_OK                = STRREF_OFFSET + 5;
int STRREF_MISSING           = STRREF_OFFSET + 6;
int STRREF_FAILED            = STRREF_OFFSET + 7;
int STRREF_ALLREQSOK         = STRREF_OFFSET + 8;
int STRREF_SOMEREQSMISSING   = STRREF_OFFSET + 9;
int STRREF_MARKETPRICE       = STRREF_OFFSET + 10;
int STRREF_GPCOST            = STRREF_OFFSET + 11;
int STRREF_XPCOST            = STRREF_OFFSET + 12;
int STRREF_CHECKDC           = STRREF_OFFSET + 13;
int STRREF_TRYTOWRITERECIPE  = STRREF_OFFSET + 14;
int STRREF_CANTUNDERSTAND    = STRREF_OFFSET + 15;
int STRREF_CANTUSETHIS       = STRREF_OFFSET + 16;
int STRREF_INVALIDRECIPE     = STRREF_OFFSET + 17;
int STRREF_SPELL             = STRREF_OFFSET + 22;
int STRREF_FEAT              = STRREF_OFFSET + 23;
int STRREF_CRAFTTIMER        = STRREF_OFFSET + 24;
int STRREF_CRAFTDISABLED     = STRREF_OFFSET + 27;
int STRREF_SPECIAL           = STRREF_OFFSET + 28;
int STRREF_NEED1GOLD         = STRREF_OFFSET + 29;

const int STRREF_CASTERLEVEL = 2301;
const int STRREF_LEVEL       = 2318;
const int STRREF_XP          = 62480;
const int STRREF_AREA        = 7373;
const int STRREF_ITEM        = 6586;
const int STRREF_RANK        = 2316;
const int STRREF_RACE        = 148;
const int STRREF_SUBRACE     = 7523;
const int STRREF_DEITY       = 152;

const int STRREF_ALIGNMENT   = 142;
const int STRREF_LG          = 112;
const int STRREF_NG          = 115;
const int STRREF_CG          = 118;
const int STRREF_LN          = 113;
const int STRREF_N           = 116;
const int STRREF_CN          = 119;
const int STRREF_LE          = 114;
const int STRREF_NE          = 117;
const int STRREF_CE          = 120;


const int RESULT_TYPE_ITEM      = 1;
const int RESULT_TYPE_CREATURE  = 2;
const int RESULT_TYPE_PLACEABLE = 3;
const int RESULT_TYPE_SCRIPT    = 4;


struct ireqreport
{
    string result;
    int    validrecipe;
    int    stacksize;
    int    marketprice;
    int    GPcost;
    int    XPcost;

    int display, consume;

    //RESULT_TYPE_*
    int result_type;

    //string RESULT only
    string result_args;

    object recipe;

    //all AND requisites
    int ANDparams;

    //ORed requisites
    int Race, Align, Area, Deity, FeatOR, SpellOR, SkillOR, LevelOR, HelperOR, ScriptOR;

    //percentage of owned items (from 0.0 to 1.0)
    float ItemOR;

    //message for that recipe
    string message;
};

struct convocc_req {
    int row;

    string ReqType;
    string ReqParam1;
    string ReqParam2;
};

/************************
 * FUNCTIONS PROTOTYPES *
 ************************/

//PUBLIC FUNCTIONS

// Read the "recipe" item and display the item requirements.
// The recipe tag MUST be exactly the same as the filename of the sRecipe 2DA.
// example: If "ireq_mring023" is the tag of the recipe item then
// the ireq table must be "ireq_mring023.2da".  I use the convention of "ireq_" to
// maintain the readability of the ireqs 2DAs along with all the other 2DAs.
struct ireqreport CheckIReqs(object oRecipe, int nDisplay=TRUE, int nConsumeIReqs=FALSE);

// Translate the oItem to its recipe if one exists and places the recipe on oPC.
// This way module makers dont have to include a bunch of recipe scrolls all over
// their module and players will always have this work in older modules.
int CreateRecipeFromItem (object oItem, object oPC);


// API for the SCRIPT and SCRIPTOR ReqTypes

//Set the requirement caption that will be displayed
void   PRCCraft_SetCaption(string sText);
string PRCCraft_GetCaption();

//TRUE (success) or FALSE (requirement missing)
void   PRCCraft_SetReturnValue(int nValue);
int    PRCCraft_GetReturnValue();

//pass ReqParam2 to the script, if any
void   PRCCraft_SetArguments(string sArguments);
string PRCCraft_GetArguments();

//return TRUE (consume whatever's needed) or FALSE (just checking)
int    PRCCraft_GetConsume();
void   PRCCraft_SetConsume(int nValue);

//timer functions

//oPC won't be able to craft anything for the next nDelay seconds
void SetCraftTimer(int nDelay, object oPC = OBJECT_SELF);

//return if the Craft Timer is active (PC can't craft)
int GetHasCraftTimer(object oPC = OBJECT_SELF);

//reset the craft timer
void ClearCraftTimer(object oPC = OBJECT_SELF);


//CheckReq FUNCTIONS

struct ireqreport CheckReqResult     (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqCasterLevel(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqLevel      (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqExtraXP    (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqExtraGold  (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqFeat       (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqSpell      (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqSkill      (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqItem       (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqHelper     (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqRace       (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqAlign      (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqArea       (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqDeity      (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");
struct ireqreport CheckReqScript     (struct ireqreport report, string sReqParam1, string sReqParam2, string extras="");


//INFORMATION FETCHING FUNCTIONS

// Get name of feat.
string GetFeatName(int nFeatID);

// Get name of spell.
string GetSpellName(int nSpellID);

// Get name of skill.
string GetSkillName(int nSkillID);

// Get name of race.
string GetRacialTypeName(int nRacialTypeID);

// Get name of class.
string GetClassName(int nClassID);

// Get Alignment of the oTarget
string GetAlign(object oTarget=OBJECT_SELF);

// Get the localized form for an alignment returned by GetAlign
string GetLocalizedAlignment(string sAlign);

// Get oTarget's free XP (extra XP beyond those used for char levels)
int GetAvailXP(object oTarget=OBJECT_SELF);

//check if target item has a corresponding recipe
string GetRecipeTagFromItem(string sResRef);

//sequentially acquire data
struct convocc_req convocc_GetReqs(string file, int row);

void prccache_error(string msg)
{
    msg = "**prccache error** " + msg;
    object oPC = GetFirstPC();
    while (oPC != OBJECT_INVALID) {
        SendMessageToPC(oPC, msg);
        oPC = GetNextPC();
    }

    PrintString(msg);
}

//MISC FUNCTIONS

// Do THESE ones require an explanation? ;)
//int max(int a, int b) {return (a > b ? a : b);} - Moved to inc_utility - Ornedan
//int min(int a, int b) {return (a < b ? a : b);}


//VARIABLES

//temporary safe container. We assume it's EMPTY!
//it has to be created by the calling function
object oTempContainer = IPGetIPWorkContainer();


/******************
 * IMPLEMENTATION *
 ******************/


/********************
 * PUBLIC FUNCTIONS *
 ********************/

int CreateRecipeFromItem(object oItem, object oPC)
{
    string sItemResRef = GetResRef(oItem);
    string sRecipeTag  = GetRecipeTagFromItem(sItemResRef);

    if (sRecipeTag != "") {
        object oRecipe = CreateObject(OBJECT_TYPE_ITEM, "itemrecipe", GetLocation(oPC), FALSE, sRecipeTag);
        ActionDoCommand(ActionPickUpItem(oRecipe));
        return TRUE;
    } else {
        return FALSE;
    }
}


struct ireqreport CheckIReqs(object oRecipe, int nDisplay=TRUE, int nConsumeIReqs=FALSE)
{
    string sRecipe = GetTag(oRecipe);

    object oTempObject;
    struct ireqreport report;

    report.recipe      = oRecipe;

    report.result      = "";
    report.GPcost      =  0;
    report.XPcost      =  0;
    report.ANDparams   =  1;
    report.Race        = -1;
    report.Align       = -1;
    report.Area        = -1;
    report.Deity       = -1;
    report.FeatOR      = -1;
    report.SpellOR     = -1;
    report.SkillOR     = -1;
    report.LevelOR     = -1;
    report.HelperOR    = -1;
    report.ScriptOR    = -1;
    report.ItemOR      = -1.0;

    report.display     = nDisplay;
    report.consume     = nConsumeIReqs;

    if (GetHasCraftTimer(OBJECT_SELF)) {
        //can't craft new objects for some time
        SendMessageToPCByStrRef(OBJECT_SELF, STRREF_CRAFTTIMER);
        report.validrecipe = TRUE;
        return report;
    }

    struct convocc_req req;
    req.row = -1;

    int RowsRead = 0, RowsProcessed = 0;


    //scroll the recipe lines and cache them as local variables on the PC
    while (1)
    {
        req = convocc_GetReqs(sRecipe, req.row + 1);
        if (req.row == -1)
            break;

        RowsRead++;

        SetLocalString(OBJECT_SELF, "ReqType"   + IntToString(RowsRead), req.ReqType  );
        SetLocalString(OBJECT_SELF, "ReqParam1" + IntToString(RowsRead), req.ReqParam1);
        SetLocalString(OBJECT_SELF, "ReqParam2" + IntToString(RowsRead), req.ReqParam2);
    }


    //process the lines. This has to be done AFTER reading them since we'll make some
    //extra DB accesses here with Get*Name()
    for (RowsProcessed = 1; RowsProcessed <= RowsRead; RowsProcessed++)
    {
        req.ReqType   = GetLocalString(OBJECT_SELF, "ReqType"   + IntToString(RowsProcessed));
        req.ReqParam1 = GetLocalString(OBJECT_SELF, "ReqParam1" + IntToString(RowsProcessed));
        req.ReqParam2 = GetLocalString(OBJECT_SELF, "ReqParam2" + IntToString(RowsProcessed));

        DeleteLocalString(OBJECT_SELF, "ReqType"   + IntToString(RowsProcessed));
        DeleteLocalString(OBJECT_SELF, "ReqParam1" + IntToString(RowsProcessed));
        DeleteLocalString(OBJECT_SELF, "ReqParam2" + IntToString(RowsProcessed));


        if      (req.ReqType == "RESULT")       report = CheckReqResult     (report, req.ReqParam1, req.ReqParam2);

        else if (req.ReqType == "CASTERLVL")    report = CheckReqCasterLevel(report, req.ReqParam1, req.ReqParam2, "ANY");
        else if (req.ReqType == "DIVCASTERLVL") report = CheckReqCasterLevel(report, req.ReqParam1, req.ReqParam2, "DIV");
        else if (req.ReqType == "ARCCASTERLVL") report = CheckReqCasterLevel(report, req.ReqParam1, req.ReqParam2, "ARC");
        else if (req.ReqType == "PSICASTERLVL") report = CheckReqCasterLevel(report, req.ReqParam1, req.ReqParam2, "PSI");

        else if (req.ReqType == "LEVEL")        report = CheckReqLevel      (report, req.ReqParam1, req.ReqParam2, "AND");
        else if (req.ReqType == "LEVELOR")      report = CheckReqLevel      (report, req.ReqParam1, req.ReqParam2, "OR" );

        else if (req.ReqType == "EXTRAXP")      report = CheckReqExtraXP    (report, req.ReqParam1, req.ReqParam2);
        else if (req.ReqType == "EXTRAGOLD")    report = CheckReqExtraGold  (report, req.ReqParam1, req.ReqParam2);

        else if (req.ReqType == "FEAT")         report = CheckReqFeat       (report, req.ReqParam1, req.ReqParam2, "AND");
        else if (req.ReqType == "FEATOR")       report = CheckReqFeat       (report, req.ReqParam1, req.ReqParam2, "OR" );

        else if (req.ReqType == "SPELL")        report = CheckReqSpell      (report, req.ReqParam1, req.ReqParam2, "AND");
        else if (req.ReqType == "SPELLOR")      report = CheckReqSpell      (report, req.ReqParam1, req.ReqParam2, "OR" );

        else if (req.ReqType == "SKILL")        report = CheckReqSkill      (report, req.ReqParam1, req.ReqParam2, "AND");
        else if (req.ReqType == "SKILLOR")      report = CheckReqSkill      (report, req.ReqParam1, req.ReqParam2, "OR" );
        else if (req.ReqType == "SKILLDC")      report = CheckReqSkill      (report, req.ReqParam1, req.ReqParam2, "DC" );

        else if (req.ReqType == "ITEM")         report = CheckReqItem       (report, req.ReqParam1, req.ReqParam2, "AND");
        else if (req.ReqType == "ITEMOR")       report = CheckReqItem       (report, req.ReqParam1, req.ReqParam2, "OR" );

        else if (req.ReqType == "HELPER")       report = CheckReqHelper     (report, req.ReqParam1, req.ReqParam2, "AND");
        else if (req.ReqType == "HELPEROR")     report = CheckReqHelper     (report, req.ReqParam1, req.ReqParam2, "OR" );

        else if (req.ReqType == "SCRIPT")       report = CheckReqScript     (report, req.ReqParam1, req.ReqParam2, "AND");
        else if (req.ReqType == "SCRIPTOR")     report = CheckReqScript     (report, req.ReqParam1, req.ReqParam2, "OR" );

        //ORed checks
        else if (req.ReqType == "RACE")         report = CheckReqRace       (report, req.ReqParam1, req.ReqParam2);
        else if (req.ReqType == "ALIGN")        report = CheckReqAlign      (report, req.ReqParam1, req.ReqParam2);
        else if (req.ReqType == "AREA")         report = CheckReqArea       (report, req.ReqParam1, req.ReqParam2);
        else if (req.ReqType == "DEITY")        report = CheckReqDeity      (report, req.ReqParam1, req.ReqParam2);

        else
            prccache_error("Unknown ReqType: " + req.ReqType + " for recipe " + sRecipe);

    }


    if (report.result == "") {
        if (RowsRead > 0)
            prccache_error("No RESULT entry for recipe: " + sRecipe);
        //not a recipe
        report.validrecipe = FALSE;
        return report;
    }

    report.validrecipe = TRUE;

    if (report.ItemOR == -1.0)      //no ItemOR requirements
        report.ItemOR = 1.0;

    //Check if requirements have been fullfilled
    if (report.ANDparams == 0 ||
        report.Race      == 0 ||
        report.Align     == 0 ||
        report.Area      == 0 ||
        report.Deity     == 0 ||
        report.FeatOR    == 0 ||
        report.SpellOR   == 0 ||
        report.SkillOR   == 0 ||
        report.LevelOR   == 0 ||
        report.HelperOR  == 0 ||
        report.ScriptOR  == 0 ||
        report.ItemOR     < 1.0)
    {
        report.result = "";
    }

    //Check GP and XP requisites (and eventually consume them)
    //Consume them even if you don't meet the requisites (i.e. you failed a skill check)
    if (report.GPcost < 0)
        report.GPcost = 0;

    int nOwnedGold = GetGold(OBJECT_SELF);
    int nOwnedXP   = GetAvailXP(OBJECT_SELF);

    if (nOwnedGold < report.GPcost || nOwnedXP < report.XPcost)
        report.result = "";

    if (report.display) {
        string sMessage = GetStringByStrRef(STRREF_MARKETPRICE) + ": " + IntToString(report.marketprice) + "\n";
        sMessage += GetStringByStrRef(STRREF_GPCOST) + ": " + IntToString(report.GPcost);
        if(GetModule() != OBJECT_SELF)
            sMessage += " - " + (nOwnedGold < report.GPcost ? GetStringByStrRef(STRREF_FAILED) : GetStringByStrRef(STRREF_OK));
        sMessage += "\n";
        sMessage += GetStringByStrRef(STRREF_XPCOST) + ": " + IntToString(report.XPcost);
        if(GetModule() != OBJECT_SELF)
            sMessage += " - " + (nOwnedXP < report.XPcost   ? GetStringByStrRef(STRREF_FAILED) : GetStringByStrRef(STRREF_OK));
        if(GetModule() != OBJECT_SELF)
        {
            sMessage += "\n";
            if (report.result != "")
                sMessage += GetStringByStrRef(STRREF_ALLREQSOK);
            else
                sMessage += GetStringByStrRef(STRREF_SOMEREQSMISSING);
        }
        SendMessageToPC(OBJECT_SELF, sMessage);
        report.message += "\n"+sMessage;
    }

    if (report.consume) {
        //Consume GP and XP if we're not meeting all the requisites, too (i.e. on a failed skill check)
        if (nOwnedGold >= report.GPcost && nOwnedXP >= report.XPcost) {
            TakeGoldFromCreature(report.GPcost, OBJECT_SELF, TRUE);
            SetXP(OBJECT_SELF, GetXP(OBJECT_SELF) - report.XPcost);
        }
    }

    return report;
}


/********************************************
 * API for the SCRIPT and SCRIPTOR ReqTypes *
 ********************************************/

//Set the requirement caption that will be displayed
void PRCCraft_SetCaption (string sText)
{SetLocalString(GetModule(), "PRCCraft_Caption", sText);}

string PRCCraft_GetCaption()
{return GetLocalString(GetModule(), "PRCCraft_Caption");}

//TRUE (success) or FALSE (requirement missing)
void PRCCraft_SetReturnValue(int nValue)
{SetLocalInt(GetModule(), "PRCCraft_ReturnValue", nValue);}

int PRCCraft_GetReturnValue()
{return GetLocalInt(GetModule(), "PRCCraft_ReturnValue");}

//pass ReqParam2 to the script, if any
void PRCCraft_SetArguments(string sArguments)
{SetLocalString(GetModule(), "PRCCraft_Arguments", sArguments);}

string PRCCraft_GetArguments()
{return GetLocalString(GetModule(), "PRCCraft_Arguments");}

//return TRUE (consume whatever's needed) or FALSE (just checking)
int PRCCraft_GetConsume()
{return GetLocalInt(GetModule(), "PRCCraft_Consume");}

void PRCCraft_SetConsume(int nValue)
{SetLocalInt(GetModule(), "PRCCraft_Consume", nValue);}


/*******************
 * timer functions *
 *******************/


//oPC won't be able to craft anything for the next nDelay seconds
void SetCraftTimer(int nDelay, object oPC = OBJECT_SELF)
{
    if (nDelay > 0) {
        SetLocalInt(GetModule(), "PRCCraftTimer" + GetName(oPC) + GetPCPlayerName(oPC), TRUE);
        DelayCommand(IntToFloat(nDelay), ClearCraftTimer(oPC));
    }
}


//return if the Craft Timer is active (PC can't craft)
int GetHasCraftTimer(object oPC = OBJECT_SELF)
{
    return GetLocalInt(GetModule(), "PRCCraftTimer" + GetName(oPC) + GetPCPlayerName(oPC));
}


//reset the craft timer
void ClearCraftTimer(object oPC = OBJECT_SELF)
{
    DeleteLocalInt(GetModule(), "PRCCraftTimer" + GetName(oPC) + GetPCPlayerName(oPC));
}


/**********************
 * CheckReq FUNCTIONS *
 **********************/

struct ireqreport CheckReqResult(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    report.result = sReqParam1;
    string sResultName = "";

    if (oTempContainer == OBJECT_INVALID)
    {
        prccache_error("CheckReqResult: no temporary container!! Are you sure you have HotU or the PRC Compatibility Pack?");
        report.result = "";
        return report;
    }

    //try inventory item
    object oTempObject = CreateItemOnObject(report.result, oTempContainer, 1);
    if (oTempObject != OBJECT_INVALID)
    {
        report.result_type = RESULT_TYPE_ITEM;

        SetIdentified(oTempObject, TRUE); // or it will get price of un-IDed item instead

        report.stacksize = StringToInt(sReqParam2);
        if (report.stacksize < 1)
            report.stacksize = GetItemStackSize(oTempObject);

        report.marketprice = GetGoldPieceValue(oTempObject) * report.stacksize;
        report.GPcost += report.marketprice / 2;
        report.XPcost += report.marketprice / 25;

        sResultName = GetName(oTempObject);
    }
    else
    {
        //try placeable
        location lLimbo = PRC_GetLimbo();
        report.result_type = RESULT_TYPE_PLACEABLE;
        oTempObject = CreateObject(OBJECT_TYPE_PLACEABLE, report.result, lLimbo);

        //try creature
        if (oTempObject == OBJECT_INVALID)
        {
            report.result_type = RESULT_TYPE_CREATURE;
            oTempObject = CreateObject(OBJECT_TYPE_CREATURE, report.result, lLimbo);
        }

        if (oTempObject != OBJECT_INVALID)
            sResultName = GetName(oTempObject);

        report.stacksize = 1;
        report.marketprice = 0;
    }

    if (oTempObject == OBJECT_INVALID)
    {
        //try script
        report.result_type = RESULT_TYPE_SCRIPT;
        PRCCraft_SetCaption("");
        PRCCraft_SetArguments(sReqParam2);
        report.result_args = sReqParam2;
        PRCCraft_SetConsume(FALSE);
        ExecuteScript(sReqParam1, OBJECT_SELF);

        sResultName = PRCCraft_GetCaption();
        report.stacksize = 1;
        report.marketprice = 0;
    }

    if (oTempObject == OBJECT_INVALID && sResultName == "") {
        prccache_error("Trying to craft an invalid object: " + sReqParam1);
        report.result = "";
        return report;
    }

    if (report.display)
    {
        string sMessage = sResultName;
        if (report.stacksize >1)
            sMessage += " x" + IntToString(report.stacksize);
        SendMessageToPC(OBJECT_SELF, sMessage);
        if(GetModule() != OBJECT_SELF)
            report.message += "\n"+sMessage;
    }

    if (oTempObject != OBJECT_INVALID) {
        SetPlotFlag(oTempObject, FALSE);
        DestroyObject(oTempObject);
    }

    return report;
}


struct ireqreport CheckReqCasterLevel(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    int nResult;
    int nRequiredCasterLevel = StringToInt(sReqParam1);

    int nLevel;

    if (extras == "DIV") {
        nLevel = GetLevelByTypeDivineFeats(OBJECT_SELF );
    } else if (extras == "ARC") {
        nLevel = GetLevelByTypeArcaneFeats(OBJECT_SELF );
    } else if (extras == "PSI") {
        nLevel = GetLevelByTypePsionicFeats(OBJECT_SELF);
    } else {
        nLevel = max(max(
            GetLevelByTypeArcaneFeats (OBJECT_SELF),
            GetLevelByTypeDivineFeats (OBJECT_SELF)),
            GetLevelByTypePsionicFeats(OBJECT_SELF));
    }

    nResult = (nLevel >= nRequiredCasterLevel);

    if (report.display) {
        string sMessage =  "* " + GetStringByStrRef(STRREF_CASTERLEVEL) + " " + sReqParam1;

        if      (extras == "DIV") sMessage += " (" + GetStringByStrRef(STRREF_DIVINE ) + ") ";
        else if (extras == "ARC") sMessage += " (" + GetStringByStrRef(STRREF_ARCANE ) + ") ";
        else if (extras == "PSI") sMessage += " (" + GetStringByStrRef(STRREF_PSIONIC) + ") ";
        if(GetModule() != OBJECT_SELF)
        {
            sMessage += ": ";
            if (nResult == TRUE)
                sMessage += GetStringByStrRef(STRREF_OK);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);

            SendMessageToPC(OBJECT_SELF, sMessage);
        }
        report.message += "\n"+sMessage;
    }

    report.ANDparams &= nResult;
    return report;
}



struct ireqreport CheckReqLevel(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    int nRequiredClass = StringToInt(sReqParam1);
    int nRequiredLevel = StringToInt(sReqParam2);
    int nLevel = GetLevelByClass(nRequiredClass);
    int nResult = (nLevel >= nRequiredLevel);

    if (report.display) {
        string sMessage = "* " + GetClassName(nRequiredClass) + " " + GetStringByStrRef(STRREF_LEVEL) + " " + sReqParam2;
        if (extras == "OR")
            sMessage += " (" + GetStringByStrRef(STRREF_OR) + ")";
        if(GetModule() != OBJECT_SELF)
        {
            sMessage += ": ";

            if (nResult == TRUE)
                sMessage += GetStringByStrRef(STRREF_OK);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);
            SendMessageToPC(OBJECT_SELF, sMessage);
        }
        report.message += "\n"+sMessage;
    }

    if (extras == "OR") {
        if (report.LevelOR == -1)
            report.LevelOR = nResult;
        else
            report.LevelOR |= nResult;
    } else
        report.ANDparams &= nResult;

    return report;
}


struct ireqreport CheckReqExtraXP(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    report.XPcost += StringToInt(sReqParam1);
    return report;
}


struct ireqreport CheckReqExtraGold(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    report.GPcost += StringToInt(sReqParam1);
    return report;
}


struct ireqreport CheckReqFeat(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    int nFeat =  StringToInt(sReqParam1);
    int nResult = GetHasFeat(nFeat);
    string sMessage;
    if (report.display) {
        sMessage = "* " + GetStringByStrRef(STRREF_FEAT) + ": " + GetFeatName(nFeat);
        if (extras == "OR")
            sMessage += " (" + GetStringByStrRef(STRREF_OR) + ")";
        if(GetModule() != OBJECT_SELF)
        {
            sMessage += ": ";

            if (nResult == TRUE)
                sMessage += GetStringByStrRef(STRREF_OK);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);
                SendMessageToPC(OBJECT_SELF, sMessage);
        }
    }
    report.message += "\n"+sMessage;

    if (extras == "OR") {
        if (report.FeatOR == -1)
            report.FeatOR = nResult;
        else
            report.FeatOR |= nResult;
    } else
        report.ANDparams &= nResult;

    return report;
}


struct ireqreport CheckReqSpell(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    int nSpell = StringToInt(sReqParam1);
    int nResult = (GetLocalInt(report.recipe, "Spell" + IntToString(nSpell)) > 0 || GetHasSpell(nSpell) > 0);

    string sMessage;
    if (report.display)
    {
        sMessage = "* " + GetStringByStrRef(STRREF_SPELL) + ": " + GetSpellName(nSpell);
        if (extras == "OR")
            sMessage += " (" + GetStringByStrRef(STRREF_OR) + ")";

        if(GetModule() != OBJECT_SELF)
        {
            sMessage += ": ";

            if (nResult == TRUE)
                sMessage += GetStringByStrRef(STRREF_OK);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);
            SendMessageToPC(OBJECT_SELF, sMessage);
        }
    }
    report.message += "\n"+sMessage;

    if (report.consume && nResult && (extras != "OR" || report.SpellOR != 1))
    {
        if (GetLocalInt(report.recipe, "Spell" + IntToString(nSpell)) == 0)
            DecrementRemainingSpellUses(OBJECT_SELF, nSpell);   //consume only if it's not been already cast on recipe
    }

    if (extras == "OR")
    {
        if (report.SpellOR == -1)
            report.SpellOR = nResult;
        else
            report.SpellOR |= nResult;
    } else
        report.ANDparams &= nResult;

    return report;
}


struct ireqreport CheckReqSkill(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    int nSkill     = StringToInt(sReqParam1);
    int nDC        = StringToInt(sReqParam2);
    int nSkillRank = GetSkillRank(nSkill);
    int nResult;

    if (extras == "DC") {
        if (report.consume)
            nResult = GetIsSkillSuccessful(OBJECT_SELF, nSkill, nDC);
        else
            nResult = (GetSkillRank(nSkill) + 20 >= nDC);
    } else
        nResult = (GetSkillRank(nSkill) >= nDC);

    string sMessage;
    if (report.display) {
        sMessage = "* " + GetSkillName(nSkill);
        if (extras == "OR")
            sMessage += " " + sReqParam2 + " (" + GetStringByStrRef(STRREF_OR) + ")";
        else if (extras == "DC")
            sMessage += " " + GetStringByStrRef(STRREF_CHECKDC) + sReqParam2;
        else
            sMessage += " " + sReqParam2;
        if(GetModule() != OBJECT_SELF)
        {
            sMessage += ": ";

            if (nResult == TRUE)
                sMessage += GetStringByStrRef(STRREF_OK);
            else if (extras == "DC")
                sMessage += GetStringByStrRef(STRREF_FAILED);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);

            SendMessageToPC(OBJECT_SELF, sMessage);
        }
    }
    report.message += "\n"+sMessage;

    if (extras == "OR") {
        if (report.SkillOR == -1)
            report.SkillOR = nResult;
        else
            report.SkillOR |= nResult;
    } else
        report.ANDparams &= nResult;

    return report;
}


struct ireqreport CheckReqItem(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    int nOwnedStackSize = 0;

    int nRequiredStackSize = StringToInt(sReqParam2);
    if (nRequiredStackSize < 1)
        nRequiredStackSize = 1;

    if (extras == "OR") {
        if (report.ItemOR == -1.0)
            report.ItemOR = 0.0;
        nOwnedStackSize = FloatToInt(IntToFloat(nRequiredStackSize) * report.ItemOR);
    }

    if (oTempContainer == OBJECT_INVALID) {
        prccache_error("CheckReqItem: no temporary container!! Are you sure you have HotU or the PRC Compatibility Pack?");
        report.ItemOR = 0.0;
        report.ANDparams = 0;
        return report;
    }

    // Spawn item into secure temporary location,
    // get name, cost and default stack size off it, then vaporize it.
    object oTempObject = CreateItemOnObject(sReqParam1, oTempContainer,1);
    if (oTempObject == OBJECT_INVALID) {
        prccache_error("Invalid ITEM or ITEMOR prerequisite: " + sReqParam1);
        return report;
    }
    SetIdentified(oTempObject, TRUE); // or it will get price of un-IDed item instead

    int nItemCost = GetGoldPieceValue(oTempObject);

    //begin to generate message
    string sMessage;
    if (report.display) {
        sMessage = "* " + GetStringByStrRef(STRREF_ITEM) + ": " + GetName(oTempObject);
        if (nRequiredStackSize > 1)
            sMessage += " x" + IntToString(nRequiredStackSize);
        if (extras == "OR")
            sMessage += " (" + GetStringByStrRef(STRREF_OR) + ")";
        if(GetModule() != OBJECT_SELF)
            sMessage += ": ";
    }

    SetPlotFlag(oTempObject, FALSE);
    DestroyObject(oTempObject);

    //Cycle through all objects in inventory until an adequate amount is reached
    oTempObject = GetFirstItemInInventory(OBJECT_SELF);
    while (oTempObject != OBJECT_INVALID && nOwnedStackSize < nRequiredStackSize)
    {
        string sTempResRef = GetResRef(oTempObject);
        if (sTempResRef == sReqParam1) {
            int nTempStackSize = GetItemStackSize(oTempObject);

            if (nTempStackSize == 0)
                nTempStackSize = 1;
            nOwnedStackSize += nTempStackSize;

            int nConsumedStackSize = 0;

            //Consume item
            if (report.consume) {
                if (nOwnedStackSize <= nRequiredStackSize) {
                    SetPlotFlag(oTempObject, FALSE);
                    DestroyObject(oTempObject);
                    nConsumedStackSize = nTempStackSize;
                } else {
                    //reduce stack size
                    nConsumedStackSize = nTempStackSize - nOwnedStackSize + nRequiredStackSize;
                    nTempStackSize -= nConsumedStackSize;
                    SetItemStackSize(oTempObject, nTempStackSize);
                }

                //subtract the creation cost of the consumed item, which is half of its market price
                report.GPcost -= nItemCost * nConsumedStackSize / 2;

            }

        }
        oTempObject = GetNextItemInInventory(OBJECT_SELF);
    }


    if (report.display && GetModule() != OBJECT_SELF)
    {
        if (nOwnedStackSize >= nRequiredStackSize)
            sMessage += GetStringByStrRef(STRREF_OK);
        else
            sMessage += GetStringByStrRef(STRREF_MISSING);
        SendMessageToPC(OBJECT_SELF, sMessage);
    }
    report.message += "\n"+sMessage;


    if (extras == "OR")
        report.ItemOR = IntToFloat(nOwnedStackSize) / IntToFloat(nRequiredStackSize);
    else
        report.ANDparams &= (nOwnedStackSize >= nRequiredStackSize);

    return report;
}


struct ireqreport CheckReqHelper(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    float fDistanceMax = StringToFloat(sReqParam2);
    if (fDistanceMax == 0.0)
        fDistanceMax = 5.0; //1 square

    object oHelper = GetNearestObjectByTag(sReqParam1);

    if (oHelper != OBJECT_INVALID && GetDistanceToObject(oHelper) > fDistanceMax)
        oHelper = OBJECT_INVALID;

    if (oHelper == OBJECT_INVALID) {
        oHelper = GetFirstItemInInventory(OBJECT_SELF);
        while (oHelper != OBJECT_INVALID) {
            if (GetTag(oHelper) == sReqParam1)
                break;
            oHelper = GetNextItemInInventory(OBJECT_SELF);
        }
    }

    int nResult = (oHelper != OBJECT_INVALID);
    string sMessage;
    if (report.display) {
        //Get Helper's name
        string sHelperName;
        object oSampleHelper = GetObjectByTag(sReqParam1);
        if (oSampleHelper == OBJECT_INVALID)
            sHelperName = sReqParam1;
        else
            sHelperName = GetName(oSampleHelper);

        sMessage = "* " + GetStringByStrRef(STRREF_HELPER) + ": " + sHelperName;
        if (extras == "OR")
            sMessage += " (" + GetStringByStrRef(STRREF_OR) + ")";
        if(GetModule() != OBJECT_SELF)
        {
            sMessage += ": ";

            if (nResult)
                sMessage += GetStringByStrRef(STRREF_OK);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);
            SendMessageToPC(OBJECT_SELF, sMessage);
        }
    }
    report.message += "\n"+sMessage;

    if (extras == "OR") {
        if (report.HelperOR == -1)
            report.HelperOR = nResult;
        else
            report.HelperOR |= nResult;
    } else
        report.ANDparams &= nResult;

    return report;
}


struct ireqreport CheckReqScript(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    PRCCraft_SetCaption("");
    PRCCraft_SetReturnValue(FALSE);
    PRCCraft_SetArguments(sReqParam2);
    PRCCraft_SetConsume(report.consume);

    ExecuteScript(sReqParam1, OBJECT_SELF);

    int nResult = PRCCraft_GetReturnValue();
    string sMessage;
    if (report.display)
    {
        sMessage = "* " + GetStringByStrRef(STRREF_SPECIAL);
        sMessage += ": ";

        string sCaption = PRCCraft_GetCaption();
        if (sCaption != "")
            sMessage = sCaption;

        if (extras == "OR")
            sMessage += " (" + GetStringByStrRef(STRREF_OR) + ")";

        if(GetModule() != OBJECT_SELF)
        {
            if (sCaption != "" || extras == "OR")
                sMessage += ": ";

            if (nResult)
                sMessage += GetStringByStrRef(STRREF_OK);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);
            SendMessageToPC(OBJECT_SELF, sMessage);
        }
    }
    report.message += "\n"+sMessage;

    if (extras == "OR") {
        if (report.ScriptOR == -1)
            report.ScriptOR = nResult;
        else
            report.ScriptOR |= nResult;
    } else
        report.ANDparams &= nResult;

    return report;
}


struct ireqreport CheckReqRace(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    int nRace   = StringToInt(sReqParam1);
    int nResult = (GetRacialType(OBJECT_SELF) == nRace);

    if (sReqParam2 != "")
        nResult &= (GetSubRace(OBJECT_SELF) == sReqParam2);
    string sMessage;
    if (report.display)
    {
        sMessage = "* " + GetStringByStrRef(STRREF_RACE);
        sMessage += ": ";
        if (sReqParam2 == "")
            sMessage += GetRacialTypeName(nRace);
        else
            sMessage += sReqParam2;
        if(GetModule() != OBJECT_SELF)
        {
            sMessage += ": ";

            if (nResult == TRUE)
                sMessage += GetStringByStrRef(STRREF_OK);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);
            SendMessageToPC(OBJECT_SELF, sMessage);
        }
    }
    report.message += "\n"+sMessage;

    if (report.Race == -1)
        report.Race = nResult;
    else
        report.Race |= nResult;

    return report;
}


struct ireqreport CheckReqAlign(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    int nResult = (GetAlign(OBJECT_SELF) == sReqParam1);
    string sMessage;
    if (report.display) {
        sMessage = "* " + GetStringByStrRef(STRREF_ALIGNMENT);
        if(GetModule() != OBJECT_SELF)
        {
            sMessage += ": " + GetLocalizedAlignment(sReqParam1) + ": ";

            if (nResult == TRUE)
                sMessage += GetStringByStrRef(STRREF_OK);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);
        }
        SendMessageToPC(OBJECT_SELF, sMessage);
    }
    report.message += "\n"+sMessage;

    if (report.Align == -1)
        report.Align = nResult;
    else
        report.Align |= nResult;

    return report;
}


struct ireqreport CheckReqArea(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    string sCurrentArea = GetTag(GetArea(OBJECT_SELF));
    int nResult = (FindSubString(sCurrentArea, sReqParam1) != -1);
    string sMessage;
    if (report.display)
    {
        object oRefArea = OBJECT_INVALID;
        if (sReqParam2 != "")
            oRefArea = GetObjectByTag(sReqParam2);
        if (oRefArea == OBJECT_INVALID)
            oRefArea = GetObjectByTag(sReqParam1);

        sMessage = "* " + GetStringByStrRef(STRREF_AREA) + ": ";
        if (oRefArea != OBJECT_INVALID)
            sMessage += GetName(oRefArea);
        else
            sMessage += sReqParam1;     //just display the TAG

        if(GetModule() != OBJECT_SELF)
        {
            sMessage += ": ";

            if (nResult == TRUE)
                sMessage += GetStringByStrRef(STRREF_OK);
            else
                sMessage += GetStringByStrRef(STRREF_MISSING);
        }
        SendMessageToPC(OBJECT_SELF, sMessage);
    }
    report.message += "\n"+sMessage;

    if (report.Area == -1)
        report.Area = nResult;
    else
        report.Area |= nResult;

    return report;
}


struct ireqreport CheckReqDeity(struct ireqreport report, string sReqParam1, string sReqParam2, string extras="")
{
    int nResult = (GetDeity(OBJECT_SELF) == sReqParam1);
    string sMessage;
    sMessage = "* " + GetStringByStrRef(STRREF_DEITY) + ": " + sReqParam1 + ": ";

    if (nResult == TRUE)
        sMessage += GetStringByStrRef(STRREF_OK);
    else
        sMessage += GetStringByStrRef(STRREF_MISSING);
    if(GetModule() == OBJECT_SELF)
        sMessage = "* " + GetStringByStrRef(STRREF_DEITY);

    if (report.display)
        SendMessageToPC(OBJECT_SELF, sMessage);
    report.message += "\n"+sMessage;

    if (report.Deity == -1)
        report.Deity = nResult;
    else
        report.Deity |= nResult;

    return report;
}


/**********************************
 * INFORMATION FETCHING FUNCTIONS *
 **********************************/

string __GetName(string table, string resref, string label, int row)
{
    string sName = GetStringByStrRef(StringToInt(Get2DACache(table, resref ,row)));
    if (sName != "" && sName != "Bad StrRef")
        return sName;
    else
        return Get2DACache(table, label, row);
}


string GetFeatName(int nFeatID)
{return __GetName("feat", "Feat", "Label", nFeatID);}

string GetSpellName(int nSpellID)
{return __GetName("spells", "Name", "Label", nSpellID);}

string GetSkillName(int nSkillID)
{return __GetName("skills", "Name", "Label", nSkillID);}

string GetRacialTypeName(int nRacialTypeID)
{return __GetName("racialtypes", "Name", "Label", nRacialTypeID);}

string GetClassName(int nClassID)
{return __GetName("classes", "Name", "Label", nClassID);}


string GetAlign(object oTarget=OBJECT_SELF)
{
    // Check Ethical Axis
    int nAlignEthical = GetAlignmentLawChaos(oTarget);
    string sAlignEthical;
    switch (nAlignEthical)
    {
        case ALIGNMENT_LAWFUL:
            sAlignEthical = "L";  break;
        case ALIGNMENT_NEUTRAL:
            sAlignEthical = "N";  break;
        case ALIGNMENT_CHAOTIC:
            sAlignEthical = "C";  break;
        default:
            sAlignEthical = "";  break;
    }

    // Check Moral Axis
    int nAlignMoral = GetAlignmentGoodEvil(oTarget);
    string sAlignMoral;
    switch (nAlignMoral)
    {
        case ALIGNMENT_GOOD:
            sAlignMoral = "G";  break;
        case ALIGNMENT_NEUTRAL:
            sAlignMoral = "N";  break;
        case ALIGNMENT_EVIL:
            sAlignMoral = "E";  break;
        default:
            sAlignMoral = "";  break;
    }

    // Reformat True Neutral
    string sPlayerAlign = sAlignEthical + sAlignMoral;
    if (sPlayerAlign == "NN")
        {sPlayerAlign = "N";}
    return sPlayerAlign;
}


string GetLocalizedAlignment(string sAlign)
{
    int nStrRef;

    if      (sAlign == "LG") nStrRef = STRREF_LG;
    else if (sAlign == "LN") nStrRef = STRREF_LN;
    else if (sAlign == "LE") nStrRef = STRREF_LE;
    else if (sAlign == "NG") nStrRef = STRREF_NG;
    else if (sAlign == "N" ) nStrRef = STRREF_N ;
    else if (sAlign == "NE") nStrRef = STRREF_NE;
    else if (sAlign == "CG") nStrRef = STRREF_CG;
    else if (sAlign == "CN") nStrRef = STRREF_CN;
    else if (sAlign == "CE") nStrRef = STRREF_CE;

    return GetStringByStrRef(nStrRef);
}


int GetAvailXP(object oTarget=OBJECT_SELF)
{
    int nRow = GetCharacterLevel(oTarget) - 1;
    int nAvailXP = GetXP(oTarget) - StringToInt(Get2DACache("exptable", "XP", nRow));
    return nAvailXP;
}


string GetRecipeTagFromItem(string sResRef)
{
    if (GetPRCSwitch(PRC_USE_DATABASE))
    {
        string q = PRC_SQLGetTick();
        //NWNX2/SQL
        //string sQuery = "SELECT file FROM prccache_reqs WHERE ReqType='RESULT' AND ReqParam1='" + sResRef + "'";
        string sQuery = "SELECT "+q+"recipe_tag"+q+" FROM "+q+"prc_cached2da_item_to_ireq"+q+" WHERE "+q+"l_resref"+q+"='"+sResRef+"'";
        PRC_SQLExecDirect(sQuery);
        if (PRC_SQLFetch() == PRC_SQL_ERROR)
            return "";
        else
            return PRC_SQLGetData(1);
    }

    else {
        //Plain slow 2DA

        object oModule = GetModule();

        if (GetLocalInt(oModule, "PRC_cache_item_to_ireq") == FALSE)
        {
            //Cache item_to_ireq into module variables
            int row;
            for (row = 0; row <= GetPRCSwitch(FILE_END_ITEM_TO_IREQ); row++)
            {
                string sResRefRead = Get2DACache("item_to_ireq", "L_RESREF"  , row);
                if (sResRefRead != "")
                {
                    string sTagRead    = Get2DACache("item_to_ireq", "RECIPE_TAG", row);
                    SetLocalString(oModule, "item_to_ireq" + sResRefRead, sTagRead);
                }
            }
            SetLocalInt(GetModule(), "PRC_cache_item_to_ireq", TRUE);
        }

        //Test the cached item_to_ireq
        return GetLocalString(oModule, "item_to_ireq" + sResRef);
    }

    //never reached
    return "";
}

struct convocc_req convocc_GetReqs(string file, int row)
{
    struct convocc_req req;

    if (GetPRCSwitch(PRC_USE_DATABASE))
    {
        //NWNX2/SQL
        if (row == 0)
        {
            //string sQuery = "SELECT reqtype,reqparam1,reqparam2 FROM prccache_reqs WHERE file='" + file + "' ORDER BY ID";
            string q = PRC_SQLGetTick();
            string sQuery = "SELECT "+q+"reqtype"+q+", "+q+"reqparam1"+q+", "+q+"reqparam2"+q+" FROM "+q+"prc_cached2da_ireq"+q+" WHERE "+q+"file"+q+"='" + file + "'";
            PRC_SQLExecDirect(sQuery);
        }

        if (PRC_SQLFetch() == PRC_SQL_ERROR) {
            req.row = -1;
        } else {
            req.row       = row;
            req.ReqType   = PRC_SQLGetData(1);
            req.ReqParam1 = PRC_SQLGetData(2);
            req.ReqParam2 = PRC_SQLGetData(3);
        }
    }

    else {
        //Plain slow 2DA
        while (1)
        {
            req.ReqType  = Get2DACache(file, "ReqType", row);
            if (req.ReqType != "")
                break;

            row++;
            if (row > GetPRCSwitch(FILE_END_IREQ)) {
                req.row = -1;
                return req;
            }
        }

        req.row   = row;
        req.ReqParam1 = Get2DACache(file, "ReqParam1", row);
        req.ReqParam2 = Get2DACache(file, "ReqParam2", row);
    }

    return req;
}