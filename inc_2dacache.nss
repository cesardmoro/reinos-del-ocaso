/** @file
 * Caching 2da read function and related.
 *
 * @author Primogenitor
 *
 * @todo Document the constants and functions
 */

const int PRC_SQL_ERROR = 0;
const int PRC_SQL_SUCCESS = 1;

string Get2DACache(string s2DA, string sColumn, int nRow, string s = "", int nDebug = FALSE);
void PRC_SQLInit();
void PRC_SQLExecDirect(string sSQL);
int PRC_SQLFetch();
string PRC_SQLGetData(int iCol);
void PRC_SQLCommit();
string PRC_SQLGetTick();

// Problems can arise with SQL commands if variables or values have single quotes
// in their names. These functions are a replace these quote with the tilde character
string ReplaceSingleChars(string sString, string sTarget, string sReplace);


//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "inc_utility" // Supplies prc_inc_switch



//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////

void PRC_SQLCommit()
{
    int nInterval = GetPRCSwitch(PRC_DB_SQLLITE_INTERVAL);
    if(nInterval == 0)
        nInterval = 600;
    float fDelay = IntToFloat(nInterval);
    DelayCommand(fDelay, PRC_SQLCommit());
    string SQL = "COMMIT";
    PRC_SQLExecDirect(SQL);
    SQL = "BEGIN IMMEDIATE";
    PRC_SQLExecDirect(SQL);
}

void PRC_SQLInit()
{
    int i;

    // Placeholder for ODBC persistence
    string sMemory;

    for (i = 0; i < 8; i++)     // reserve 8*128 bytes
        sMemory +=
            "................................................................................................................................";

    SetLocalString(GetModule(), "NWNX!ODBC!SPACER", sMemory);
}

void PRC_SQLExecDirect(string sSQL)
{
//PrintString(sSQL);
    SetLocalString(GetModule(), "NWNX!ODBC!EXEC", sSQL);
}

int PRC_SQLFetch()
{
    string sRow;
    object oModule = GetModule();

    SetLocalString(oModule, "NWNX!ODBC!FETCH", GetLocalString(oModule, "NWNX!ODBC!SPACER"));
    sRow = GetLocalString(oModule, "NWNX!ODBC!FETCH");
    if (GetStringLength(sRow) > 0)
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", sRow);
        return PRC_SQL_SUCCESS;
    }
    else
    {
        SetLocalString(oModule, "NWNX_ODBC_CurrentRow", "");
        return PRC_SQL_ERROR;
    }
}

string PRC_SQLGetTick()
{
    string sTick;
    if(GetPRCSwitch(PRC_DB_SQLLITE))
        sTick = "";
    else
        sTick = "`";
    return sTick;
}

string PRC_SQLGetData(int iCol)
{
    int iPos;
    string sResultSet = GetLocalString(GetModule(), "NWNX_ODBC_CurrentRow");

    // find column in current row
    int iCount = 0;
    string sColValue = "";

    iPos = FindSubString(sResultSet, "¬");
    if ((iPos == -1) && (iCol == 1))
    {
        // only one column, return value immediately
        sColValue = sResultSet;
    }
    else if (iPos == -1)
    {
        // only one column but requested column > 1
        sColValue = "";
    }
    else
    {
        // loop through columns until found
        while (iCount != iCol)
        {
            iCount++;
            if (iCount == iCol)
                sColValue = GetStringLeft(sResultSet, iPos);
            else
            {
                sResultSet = GetStringRight(sResultSet, GetStringLength(sResultSet) - iPos - 1);
                iPos = FindSubString(sResultSet, "¬");
            }

            // special case: last column in row
            if (iPos == -1)
                iPos = GetStringLength(sResultSet);
        }
    }

    return sColValue;
}


string ReplaceSingleChars(string sString, string sTarget, string sReplace)
{
    if (FindSubString(sString, sTarget) == -1) // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)
    {
        sChar = GetSubString(sString, i, 1);
        if (sChar == sTarget)
            sReturn += sReplace;
        else
            sReturn += sChar;
    }
    return sReturn;
}

void PRCMakeTables()
{
    string SQL;
    if(GetPRCSwitch(PRC_DB_SQLLITE))
        SQL += "PRAGMA page_size=4096; ";

    string q = PRC_SQLGetTick();

    PRC_SQLExecDirect(SQL); SQL = "";
    SQL+= "CREATE TABLE ";
    SQL+= ""+q+"prc_cached2da_feat"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"LABEL"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"FEAT"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"DESCRIPTION"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"ICON"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MINATTACKBONUS"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MINSTR"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MINDEX"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MININT"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MINWIS"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MINCON"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MINCHA"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MINSPELLLVL"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"PREREQFEAT1"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"PREREQFEAT2"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"GAINMULTIPLE"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"EFFECTSSTACK"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"ALLCLASSESCANUSE"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"CATEGORY"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MAXCR"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"SPELLID"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"SUCCESSOR"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"CRValue"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"USESPERDAY"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MASTERFEAT"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"TARGETSELF"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"OrReqFeat0"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"OrReqFeat1"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"OrReqFeat2"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"OrReqFeat3"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"OrReqFeat4"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"REQSKILL"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"ReqSkillMinRanks"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"REQSKILL2"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"ReqSkillMinRanks2"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"Constant"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"TOOLSCATEGORIES"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"HostileFeat"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MinLevel"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MinLevelClass"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MaxLevel"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"MinFortSave"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"PreReqEpic"+q+" varchar(255) DEFAULT '_',";
    SQL+= ""+q+"ReqAction"+q+" varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE ";
    SQL+= ""+q+"prc_cached2da_soundset"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"LABEL"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"RESREF"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"STRREF"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"GENDER"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"TYPE"+q+" varchar(255) ); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE ";
    SQL+= ""+q+"prc_cached2da_portraits"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"BaseResRef"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Sex"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Race"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"InanimateType"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Plot"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"LowGore"+q+" varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE ";
    SQL+= ""+q+"prc_cached2da_appearance"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"LABEL"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"STRING_REF"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"NAME"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"RACE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ENVMAP"+q+"  varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"BLOODCOLR"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"MODELTYPE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"WEAPONSCALE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"WING_TAIL_SCALE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HELMET_SCALE_M"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HELMET_SCALE_F"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"MOVERATE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"WALKDIST"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"RUNDIST"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"PERSPACE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"CREPERSPACE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HEIGHT"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HITDIST"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"PREFATCKDIST"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"TARGETHEIGHT"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ABORTONPARRY"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"RACIALTYPE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HASLEGS"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HASARMS"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"PORTRAIT"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SIZECATEGORY"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"PERCEPTIONDIST"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"FOOTSTEPTYPE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SOUNDAPPTYPE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HEADTRACK"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HEAD_ARC_H"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HEAD_ARC_V"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HEAD_NAME"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"BODY_BAG"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"TARGETABLE"+q+"  varchar(255) DEFAULT '_'";
    SQL+= "); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE ";
    SQL+= ""+q+"prc_cached2da_spells"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"Label"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Name"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"IconResRef"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"School"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Range"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"VS"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"MetaMagic"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"TargetType"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ImpactScript"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Bard"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Cleric"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Druid"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Paladin"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Ranger"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Wiz_Sorc"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Innate"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConjTime"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConjAnim"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConjHeadVisual"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConjHandVisual"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConjGrndVisual"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConjSoundVFX"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConjSoundMale"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConjSoundFemale"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"CastAnim"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"CastTime"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"CastHeadVisual"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"CastHandVisual"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"CastGrndVisual"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"CastSound"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Proj"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ProjModel"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ProjType"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ProjSpwnPoint"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ProjSound"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ProjOrientation"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ImmunityType"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ItemImmunity"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SubRadSpell1"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SubRadSpell2"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SubRadSpell3"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SubRadSpell4"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SubRadSpell5"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Category"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Master"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"UserType"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SpellDesc"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"UseConcentration"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SpontaneouslyCast"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"AltMessage"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HostileSetting"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"FeatID"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Counter1"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Counter2"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HasProjectile"+q+" varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE "+q+"prc_cached2da_cls_feat"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"file"+q+" varchar(255),";
    SQL+= ""+q+"class"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"FeatLabel"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"FeatIndex"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"List"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"GrantedOnLevel"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"OnMenu"+q+" varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE "+q+"prc_cached2da_classes"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"Label"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Name"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Plural"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Lower"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Description"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Icon"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"HitDie"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"AttackBonusTable"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"FeatsTable"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SavingThrowTable"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SkillsTable"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"BonusFeatsTable"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SkillPointBase"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SpellGainTable"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SpellKnownTable"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"PlayerClass"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"SpellCaster"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Str"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Dex"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Con"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Wis"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Int"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Cha"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"PrimaryAbil"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"AlignRestrict"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"AlignRstrctType"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"InvertRestrict"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Constant"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl01"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl02"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl03"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl04"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl05"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl06"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl07"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl08"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl09"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl10"+q+"varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl11"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl12"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl13"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl14"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl15"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl16"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl17"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl18"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl19"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EffCRLvl20"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"PreReqTable"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"MaxLevel"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"XPPenalty"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ArcSpellLvlMod"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"DivSpellLvlMod"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"EpicLevel"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Package"+q+" varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL = "CREATE TABLE "+q+"prc_cached2da_racialtypes"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"Label"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Abrev"+q+"  varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Name"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConverName"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConverNameLower"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"NamePlural"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Description"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Appearance"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"StrAdjust"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"DexAdjust"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"IntAdjust"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ChaAdjust"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"WisAdjust"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ConAdjust"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Endurance"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Favored"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"FeatsTable"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Biography"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"PlayerRace"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"Constant"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"AGE"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ToolsetDefaultClass"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"CRModifier"+q+" varchar(255) DEFAULT '_');";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE "+q+"prc_cached2da_ireq"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"file"+q+" varchar(255),";
    SQL+= ""+q+"LABEL"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ReqType"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ReqParam1"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"ReqParam2"+q+" varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL+= "CREATE TABLE "+q+"prc_cached2da_item_to_ireq"+q+" ( ";
    SQL+= ""+q+"rowid"+q+" varchar(255),";
    SQL+= ""+q+"LABEL"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"L_RESREF"+q+" varchar(255) DEFAULT '_', ";
    SQL+= ""+q+"RECIPE_TAG"+q+" varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    SQL = "CREATE TABLE "+q+"prc_cached2da"+q+" ("+q+"file"+q+" varchar(255) DEFAULT '_', "+q+"columnid"+q+" varchar(255) DEFAULT '_', "+q+"rowid"+q+" varchar(255), "+q+"data"+q+" varchar(255) DEFAULT '_'); ";
    PRC_SQLExecDirect(SQL); SQL = "";

    //non2dacaching table
    SQL = "CREATE TABLE "+q+"prc_data"+q+" ("+q+"name"+q+" varchar(255) DEFAULT '_', "+q+"value"+q+" varchar(255) DEFAULT '_')";
    PRC_SQLExecDirect(SQL); SQL = "";

    //indexs
    SQL+= "CREATE UNIQUE INDEX "+q+"spellsrowindex"+q+"  ON "+q+"prc_cached2da_spells"+q+" ("+q+"rowid"+q+"); ";
    SQL = "CREATE UNIQUE INDEX "+q+"featrowindex"+q+"  ON "+q+"prc_cached2da_feat"+q+" ("+q+"rowid"+q+"); ";
    SQL+= "CREATE        INDEX "+q+"clsfeatindex"+q+" ON "+q+"prc_cached2da_cls_feat"+q+" ("+q+"FeatIndex"+q+"); ";
    SQL+= "CREATE        INDEX "+q+"clsfileindex"+q+" ON "+q+"prc_cached2da_cls_feat"+q+" ("+q+"file"+q+"); ";
    SQL+= "CREATE UNIQUE INDEX "+q+"appearrowindex"+q+"  ON "+q+"prc_cached2da_appearance"+q+" ("+q+"rowid"+q+"); ";
    SQL+= "CREATE UNIQUE INDEX "+q+"portrrowindex"+q+"  ON "+q+"prc_cached2da_portrait"+q+" ("+q+"rowid"+q+"); ";
    SQL+= "CREATE UNIQUE INDEX "+q+"soundsrowindex"+q+"  ON "+q+"prc_cached2da_soundset"+q+" ("+q+"rowid"+q+"); ";
    SQL+= "CREATE UNIQUE INDEX "+q+"datanameindex"+q+" ON "+q+"prc_data"+q+" ("+q+"name"+q+"); ";
    SQL = "CREATE        INDEX "+q+"irewfileindex"+q+" ON "+q+"prc_cached2da_ireq"+q+" ("+q+"file"+q+"); ";
    SQL+= "CREATE UNIQUE INDEX "+q+"refrindex"+q+" ON "+q+"prc_cached2da_item_to_ireq"+q+" ("+q+"l_resref"+q+"); ";
    PRC_SQLExecDirect(SQL); SQL = "";

}

void PreCache(string s2DA, string sColumn, int nRow, string sValue)
{
    Get2DACache(s2DA, sColumn, nRow, sValue);
}

string Get2DACache(string s2DA, string sColumn, int nRow, string s = "", int nDebug = FALSE)
{
    //get the chest that contains the cache
    object oCacheWP = GetObjectByTag("Bioware2DACache");
    //if no chest, use HEARTOFCHAOS in limbo as a location to make a new one
    if (!GetIsObjectValid(oCacheWP))
    {
        //oCacheWP = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_chest2",
        //    GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
        //has to be an object, placeables cant go through the DB    
        oCacheWP = CreateObject(OBJECT_TYPE_CREATURE, "prc_2da_cache",
            GetLocation(GetObjectByTag("HEARTOFCHAOS")), FALSE, "Bioware2DACache");
if(nDebug) DoDebug("Get2DACache: Cache chest does not exist, creating new one");
    }
    //lower case the 2da and column
    s2DA = GetStringLowerCase(s2DA);
    sColumn = GetStringLowerCase(sColumn);

    //get the token for this file
    string sFileWPName = ""+GetStringUpperCase(s2DA)+"_"+sColumn+"_"+IntToString(nRow/1000);
if(nDebug) DoDebug("Get2DACache: token tag is "+sFileWPName);
/*    object oFileWP = GetFirstItemInInventory(oCacheWP);
    while(GetIsObjectValid(oFileWP)
        && GetTag(oFileWP) != sFileWPName)
    {
        oFileWP = GetNextItemInInventory(oCacheWP);
    }
*/  object oFileWP = GetObjectByTag(sFileWPName);
    //token doesnt exist make it
    if (!GetIsObjectValid(oFileWP))
    {
if(nDebug) DoDebug("Get2DACache: token does not exist, creating new one");
        oFileWP = CreateObject(OBJECT_TYPE_ITEM, "hidetoken", GetLocation(oCacheWP), FALSE, sFileWPName);
        DestroyObject(oFileWP);
        oFileWP = CopyObject(oFileWP, GetLocation(oCacheWP), oCacheWP, sFileWPName);

        //dont use this becuase it doesnt change the tag
        //oFileWP = CreateItemOnObject("hidetoken", oCacheWP);
        //this isnt needed cause its items in a container now
        //CreateObject(OBJECT_TYPE_WAYPOINT,"NW_WAYPOINT001",lCache,FALSE,sFileWPName);
    }

    //store to check if pushed in
    string sPushed = s;
    if(s == "")
        s = GetLocalString(oFileWP, "2DA_"+s2DA+"_"+sColumn+"_"+IntToString(nRow));

if(nDebug) DoDebug("Get2DACache: live cached value is "+s);
if(nDebug) DoDebug("Get2DACache: pushed cached value is "+sPushed);

    //check if we should use the database
    int nDB = GetPRCSwitch(PRC_USE_DATABASE);
    string SQL;


    //sColumn = ReplaceChars(sColumn, "_" , "z");
    string sDBColumn = sColumn;

    //if its not locally cached already
    //look in DB
    if (s == "" && nDB)
    {
        string q = PRC_SQLGetTick();

        if(s2DA == "feat"
            || s2DA == "spells"
            || s2DA == "portraits"
            || s2DA == "soundsets"
            || s2DA == "appearance"
            || s2DA == "portraits"
            || s2DA == "classes"
            || s2DA == "racialtypes"
            || s2DA == "item_to_ireq")
            SQL = "SELECT "+q+""+sDBColumn+""+q+" FROM "+q+"prc_cached2da_"+s2DA+""+q+" WHERE ( "+q+"rowid"+q+" = "+IntToString(nRow)+" )";
        else if(TestStringAgainstPattern("cls_feat_**", s2DA))
            SQL = "SELECT "+q+""+sDBColumn+""+q+" FROM "+q+"prc_cached2da_cls_feat"+q+" WHERE ( "+q+"rowid"+q+" = "+IntToString(nRow)+" ) AND ( "+q+"file"+q+" = '"+s2DA+"' )";
        else if(TestStringAgainstPattern("ireq_**", s2DA))
            SQL = "SELECT "+q+""+sDBColumn+""+q+" FROM "+q+"prc_cached2da_ireq"+q+" WHERE ( "+q+"rowid"+q+" = "+IntToString(nRow)+" ) AND ( "+q+"file"+q+" = '"+s2DA+"' )";
        else
            SQL = "SELECT "+q+"data"+q+" FROM "+q+"prc_cached2da"+q+" WHERE ( "+q+"file"+q+" = '"+s2DA+"' ) AND ( "+q+"columnid"+q+" = '"+sDBColumn+"' ) AND ( "+q+"rowid"+q+" = "+IntToString(nRow)+" )";

        PRC_SQLExecDirect(SQL);
        // if there is an error, table is not built or is not initialized

        //THIS LINE CRASHES NWSERVER for any colum other than the first one.
        //WISH I KNEW WHY!!!!!
        //update: its because its returning a null data.
        //the work around is to specify a default for all columns when creating the table
        if(!PRC_SQLFetch())
        {
            //WriteTimestampedLogEntry("Error getting table from DB");
        }
        else
        {
            //table exists, and no problems accessing it
            s = PRC_SQLGetData(1);
            if(s == "_")
                s="";
            //if its already in the DB, dont store it again
            if(s != "")
                nDB = FALSE;
        }
    }
    //entry didnt exist in the database
    if(s == "")
    {
        //fetch from the 2da file
        s = Get2DAString(s2DA, sColumn, nRow);
        if (s == "")
            s = "****";
    }

    if(nDB)
    {
        string q = PRC_SQLGetTick();

        //store it in the database
        //use specific tables for certain 2das
        if(s2DA == "feat"
            || s2DA == "spells"
            || s2DA == "portraits"
            || s2DA == "soundset"
            || s2DA == "appearance"
            || s2DA == "portraits"
            || s2DA == "classes"
            || s2DA == "racialtypes"
            || s2DA == "item_to_ireq")
        {
            //check that 2da row exisits
            SQL = "SELECT "+q+"rowid"+q+" FROM "+q+"prc_cached2da_"+s2DA+""+q+" WHERE "+q+"rowid"+q+"="+IntToString(nRow);
            PRC_SQLExecDirect(SQL);
            //if the row exists, then update it
            //otherwise insert a new row
            if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                && PRC_SQLGetData(1) != "")
            {
                SQL = "UPDATE "+q+"prc_cached2da_"+s2DA+""+q+" SET  "+q+""+sDBColumn+""+q+" = '"+s+"'  WHERE  "+q+"rowid"+q+" = "+IntToString(nRow)+" ";
            }
            else
            {
                SQL = "INSERT INTO "+q+"prc_cached2da_"+s2DA+""+q+" ("+q+"rowid"+q+", "+q+""+sDBColumn+""+q+") VALUES ("+IntToString(nRow)+" , '"+s+"')";
            }
        }
        else if(TestStringAgainstPattern("cls_feat_**", s2DA))
        {
            //check that 2da row exisits
            SQL = "SELECT "+q+"rowid"+q+" FROM "+q+"prc_cached2da_cls_feat"+q+" WHERE ("+q+"rowid"+q+"="+IntToString(nRow)+") AND ("+q+"file"+q+"='"+s2DA+"')";
            PRC_SQLExecDirect(SQL);
            //if the row exists, then update it
            //otherwise insert a new row
            if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                && PRC_SQLGetData(1) != "")
            {
                SQL = "UPDATE "+q+"prc_cached2da_cls_feat"+q+" SET  "+q+""+sDBColumn+""+q+" = '"+s+"'WHERE ("+q+"rowid"+q+" = "+IntToString(nRow)+") AND ("+q+"file"+q+"='"+s2DA+"')";
            }
            else
            {
                SQL = "INSERT INTO "+q+"prc_cached2da_cls_feat"+q+" ("+q+"rowid"+q+", "+q+""+sDBColumn+""+q+", "+q+"file"+q+") VALUES ("+IntToString(nRow)+" , '"+s+"', '"+s2DA+"')";
            }
        }
        else if(TestStringAgainstPattern("ireq_**", s2DA))
        {
            //check that 2da row exisits
            SQL = "SELECT "+q+"rowid"+q+" FROM "+q+"prc_cached2da_ireq"+q+" WHERE ("+q+"rowid"+q+"="+IntToString(nRow)+") AND ("+q+"file"+q+"='"+s2DA+"')";
            PRC_SQLExecDirect(SQL);
            //if the row exists, then update it
            //otherwise insert a new row
            if(PRC_SQLFetch() == PRC_SQL_SUCCESS
                && PRC_SQLGetData(1) != "")
            {
                SQL = "UPDATE "+q+"prc_cached2da_ireq"+q+" SET  "+q+""+sDBColumn+""+q+" = '"+s+"'WHERE ("+q+"rowid"+q+" = "+IntToString(nRow)+") AND ("+q+"file"+q+"='"+s2DA+"')";
            }
            else
            {
                SQL = "INSERT INTO "+q+"prc_cached2da_ireq"+q+" ("+q+"rowid"+q+", "+q+""+sDBColumn+""+q+", "+q+"file"+q+") VALUES ("+IntToString(nRow)+" , '"+s+"', '"+s2DA+"')";
            }
        }
        else
        {
            SQL = "INSERT INTO "+q+"prc_cached2da"+q+" VALUES ('"+s2DA+"' , '"+sDBColumn+"' , '"+IntToString(nRow)+"' , '"+s+"')";
        }
        PRC_SQLExecDirect(SQL);
    }
    //store it on the waypoint
    SetLocalString(oFileWP, "2DA_"+s2DA+"_"+sColumn+"_"+IntToString(nRow), s);

if(nDebug) PrintString("Get2DACache: returned value is "+s);

    if (s=="****")
        return "";
    else
        return s;
}

//Caching functions

void Cache_Done()
{
    WriteTimestampedLogEntry("2da caching complete");
}

void Cache_Ireq(int nItem, int nRow = 0)
{
    string sFile = Get2DACache("item_to_ireq", "RECIPE_TAG", nItem);
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_ireq WHERE (file = '"+GetStringLowerCase(sFile)+"') ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }

    if(sFile != ""
        && sFile != "****"
        && nRow < GetPRCSwitch(FILE_END_IREQ))
    {
        Get2DACache(sFile, "LABEL", nRow);
        Get2DACache(sFile, "ReqType", nRow);
        Get2DACache(sFile, "ReqParam1", nRow);
        Get2DACache(sFile, "ReqParam2", nRow);
        nRow++;
        DelayCommand(0.1, Cache_Ireq(nItem, nRow));
        if(nRow >= GetPRCSwitch(FILE_END_IREQ))
        {
            if(GetPRCSwitch(PRC_DB_SQLLITE))
            {
                string SQL = "COMMIT";
                PRC_SQLExecDirect(SQL);
                SQL = "BEGIN IMMEDIATE";
                PRC_SQLExecDirect(SQL);
            }
        }
    }
    else
    {
        if(nItem >= GetPRCSwitch(FILE_END_ITEM_TO_IREQ))
            Cache_Done();
        else
        {
            DelayCommand(0.1, Cache_Ireq(nItem+1)); //need to delay to prevent TMI
        }
    }
}

void Cache_Item_To_Ireq(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_item_to_ireq ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_ITEM_TO_IREQ))
    {
        Get2DACache("item_to_ireq", "Label", nRow);
        Get2DACache("item_to_ireq", "L_RESREF", nRow);
        Get2DACache("item_to_ireq", "RECIPE_TAG", nRow);
        nRow++;
        DelayCommand(0.01, Cache_Item_To_Ireq(nRow));
    }
    else
        DelayCommand(0.1, Cache_Ireq(0));
    if(nRow % 100 == 0)
    {
        if(GetPRCSwitch(PRC_DB_SQLLITE))
        {
            string SQL = "COMMIT";
            PRC_SQLExecDirect(SQL);
            SQL = "BEGIN IMMEDIATE";
            PRC_SQLExecDirect(SQL);
        }
    }
}

void Cache_Class_Feat(int nClass, int nRow = 0)
{
    string sFile = Get2DACache("classes", "FeatsTable", nClass);
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_cls_feat WHERE (file = '"+GetStringLowerCase(sFile)+"') ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(sFile != ""
        && sFile != "****"
        && nRow < GetPRCSwitch(FILE_END_CLASS_FEAT))
    {
        Get2DACache(sFile, "FeatLabel", nRow);
        Get2DACache(sFile, "FeatIndex", nRow);
        Get2DACache(sFile, "List", nRow);
        Get2DACache(sFile, "GrantedOnLevel", nRow);
        Get2DACache(sFile, "OnMenu", nRow);
        nRow++;
        DelayCommand(0.1, Cache_Class_Feat(nClass, nRow));
        if(nRow >= GetPRCSwitch(FILE_END_CLASS_FEAT))
        {
            if(GetPRCSwitch(PRC_DB_SQLLITE))
            {
                string SQL = "COMMIT";
                PRC_SQLExecDirect(SQL);
                SQL = "BEGIN IMMEDIATE";
                PRC_SQLExecDirect(SQL);
            }
        }
    }
    else
    {
        if(nClass == 254)
            Cache_Item_To_Ireq();
        else
        {
            DelayCommand(0.1, Cache_Class_Feat(nClass+1)); //need to delay to prevent TMI
        }
    }
}

void Cache_Classes(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_classes ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_CLASSES))
    {
        Get2DACache("classes", "Label", nRow);
        Get2DACache("classes", "Name", nRow);
        Get2DACache("classes", "Plural", nRow);
        Get2DACache("classes", "Lower", nRow);
        Get2DACache("classes", "Description", nRow);
        Get2DACache("classes", "Icon", nRow);
        Get2DACache("classes", "HitDie", nRow);
        Get2DACache("classes", "AttackBonusTable", nRow);
        Get2DACache("classes", "FeatsTable", nRow);
        Get2DACache("classes", "SavingThrowTable", nRow);
        Get2DACache("classes", "SkillsTable", nRow);
        Get2DACache("classes", "BonusFeatsTable", nRow);
        Get2DACache("classes", "SkillPointBase", nRow);
        Get2DACache("classes", "SpellGainTable", nRow);
        Get2DACache("classes", "SpellKnownTable", nRow);
        Get2DACache("classes", "PlayerClass", nRow);
        Get2DACache("classes", "SpellCaster", nRow);
        Get2DACache("classes", "Str", nRow);
        Get2DACache("classes", "Dex", nRow);
        Get2DACache("classes", "Con", nRow);
        Get2DACache("classes", "Wis", nRow);
        Get2DACache("classes", "Int", nRow);
        Get2DACache("classes", "Cha", nRow);
        Get2DACache("classes", "PrimaryAbil", nRow);
        Get2DACache("classes", "AlignRestrict", nRow);
        Get2DACache("classes", "AlignRstrctType", nRow);
        Get2DACache("classes", "InvertRestrict", nRow);
        Get2DACache("classes", "Constant", nRow);
        Get2DACache("classes", "EffCRLvl01", nRow);
        Get2DACache("classes", "EffCRLvl02", nRow);
        Get2DACache("classes", "EffCRLvl03", nRow);
        Get2DACache("classes", "EffCRLvl04", nRow);
        Get2DACache("classes", "EffCRLvl05", nRow);
        Get2DACache("classes", "EffCRLvl06", nRow);
        Get2DACache("classes", "EffCRLvl07", nRow);
        Get2DACache("classes", "EffCRLvl08", nRow);
        Get2DACache("classes", "EffCRLvl09", nRow);
        Get2DACache("classes", "EffCRLvl10", nRow);
        Get2DACache("classes", "EffCRLvl12", nRow);
        Get2DACache("classes", "EffCRLvl13", nRow);
        Get2DACache("classes", "EffCRLvl14", nRow);
        Get2DACache("classes", "EffCRLvl15", nRow);
        Get2DACache("classes", "EffCRLvl16", nRow);
        Get2DACache("classes", "EffCRLvl17", nRow);
        Get2DACache("classes", "EffCRLvl18", nRow);
        Get2DACache("classes", "EffCRLvl19", nRow);
        Get2DACache("classes", "EffCRLvl20", nRow);
        Get2DACache("classes", "PreReqTable", nRow);
        Get2DACache("classes", "MaxLevel", nRow);
        Get2DACache("classes", "XPPenalty", nRow);
        Get2DACache("classes", "ArcSpellLvlMod", nRow);
        Get2DACache("classes", "DivSpellLvlMod", nRow);
        Get2DACache("classes", "EpicLevel", nRow);
        Get2DACache("classes", "Package", nRow);
        nRow++;
        DelayCommand(0.1, Cache_Classes(nRow));
    }
    else
        DelayCommand(1.0, Cache_Class_Feat(0));
    if(nRow % 100 == 0)
    {
        if(GetPRCSwitch(PRC_DB_SQLLITE))
        {
            string SQL = "COMMIT";
            PRC_SQLExecDirect(SQL);
            SQL = "BEGIN IMMEDIATE";
            PRC_SQLExecDirect(SQL);
        }
    }
}

void Cache_RacialTypes(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_racialtypes ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_RACIALTYPES))
    {
        Get2DACache("racialtypes", "Label", nRow);
        Get2DACache("racialtypes", "Abrev", nRow);
        Get2DACache("racialtypes", "Name", nRow);
        Get2DACache("racialtypes", "ConverName", nRow);
        Get2DACache("racialtypes", "ConverNameLower", nRow);
        Get2DACache("racialtypes", "NamePlural", nRow);
        Get2DACache("racialtypes", "Description", nRow);
        Get2DACache("racialtypes", "Appearance", nRow);
        Get2DACache("racialtypes", "StrAdjust", nRow);
        Get2DACache("racialtypes", "DexAdjust", nRow);
        Get2DACache("racialtypes", "IntAdjust", nRow);
        Get2DACache("racialtypes", "ChaAdjust", nRow);
        Get2DACache("racialtypes", "WisAdjust", nRow);
        Get2DACache("racialtypes", "ConAdjust", nRow);
        Get2DACache("racialtypes", "Endurance", nRow);
        Get2DACache("racialtypes", "Favored", nRow);
        Get2DACache("racialtypes", "FeatsTable", nRow);
        Get2DACache("racialtypes", "Biography", nRow);
        Get2DACache("racialtypes", "PlayerRace", nRow);
        Get2DACache("racialtypes", "Constant", nRow);
        Get2DACache("racialtypes", "AGE", nRow);
        Get2DACache("racialtypes", "ToolsetDefaultClass", nRow);
        Get2DACache("racialtypes", "CRModifier", nRow);

        nRow++;
        DelayCommand(0.1, Cache_RacialTypes(nRow));
    }
    else
        DelayCommand(1.0, Cache_Classes(0));
    if(nRow % 100 == 0)
    {
        if(GetPRCSwitch(PRC_DB_SQLLITE))
        {
            string SQL = "COMMIT";
            PRC_SQLExecDirect(SQL);
            SQL = "BEGIN IMMEDIATE";
            PRC_SQLExecDirect(SQL);
        }
    }
}


void Cache_Feat(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_feat ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_FEAT))
    {
        Get2DACache("feat", "LABEL", nRow);
        Get2DACache("feat", "FEAT", nRow);
        Get2DACache("feat", "DESCRIPTION", nRow);
        Get2DACache("feat", "MINATTACKBONUS", nRow);
        Get2DACache("feat", "MINSTR", nRow);
        Get2DACache("feat", "MINDEX", nRow);
        Get2DACache("feat", "MININT", nRow);
        Get2DACache("feat", "MINWIS", nRow);
        Get2DACache("feat", "MINCON", nRow);
        Get2DACache("feat", "MINCHA", nRow);
        Get2DACache("feat", "MINSPELLLVL", nRow);
        Get2DACache("feat", "PREREQFEAT1", nRow);
        Get2DACache("feat", "PREREQFEAT2", nRow);
        Get2DACache("feat", "GAINMULTIPLE", nRow);
        Get2DACache("feat", "EFFECTSSTACK", nRow);
        Get2DACache("feat", "ALLCLASSESCANUSE", nRow);
        Get2DACache("feat", "CATEGORY", nRow);
        Get2DACache("feat", "MAXCR", nRow);
        Get2DACache("feat", "SPELLID", nRow);
        Get2DACache("feat", "SUCCESSOR", nRow);
        Get2DACache("feat", "CRValue", nRow);
        Get2DACache("feat", "USESPERDAY", nRow);
        Get2DACache("feat", "MASTERFEAT", nRow);
        Get2DACache("feat", "TARGETSELF", nRow);
        Get2DACache("feat", "OrReqFeat0", nRow);
        Get2DACache("feat", "OrReqFeat1", nRow);
        Get2DACache("feat", "OrReqFeat2", nRow);
        Get2DACache("feat", "OrReqFeat3", nRow);
        Get2DACache("feat", "OrReqFeat4", nRow);
        Get2DACache("feat", "REQSKILL", nRow);
        Get2DACache("feat", "ReqSkillMinRanks", nRow);
        Get2DACache("feat", "REQSKILL2", nRow);
        Get2DACache("feat", "ReqSkillMinRanks2", nRow);
        Get2DACache("feat", "Constant", nRow);
        Get2DACache("feat", "TOOLSCATEGORIES", nRow);
        Get2DACache("feat", "HostileFeat", nRow);
        Get2DACache("feat", "MinLevel", nRow);
        Get2DACache("feat", "MinLevelClass", nRow);
        Get2DACache("feat", "MaxLevel", nRow);
        Get2DACache("feat", "MinFortSave", nRow);
        Get2DACache("feat", "PreReqEpic", nRow);
        Get2DACache("feat", "ReqAction", nRow);
        nRow++;
        DelayCommand(0.01, Cache_Feat(nRow));
    }
    else
        DelayCommand(1.0, Cache_RacialTypes());
    if(nRow % 100 == 0)
    {
        if(GetPRCSwitch(PRC_DB_SQLLITE))
        {
            string SQL = "COMMIT";
            PRC_SQLExecDirect(SQL);
            SQL = "BEGIN IMMEDIATE";
            PRC_SQLExecDirect(SQL);
        }
    }
}

void Cache_Spells(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_spells ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_SPELLS))
    {
        Get2DACache("spells", "Label", nRow);
        Get2DACache("spells", "Name", nRow);
        Get2DACache("spells", "IconResRef", nRow);
        Get2DACache("spells", "School", nRow);
        Get2DACache("spells", "Range", nRow);
        Get2DACache("spells", "VS", nRow);
        Get2DACache("spells", "MetaMagic", nRow);
        Get2DACache("spells", "TargetType", nRow);
        Get2DACache("spells", "ImpactScript", nRow);
        Get2DACache("spells", "Bard", nRow);
        Get2DACache("spells", "Cleric", nRow);
        Get2DACache("spells", "Druid", nRow);
        Get2DACache("spells", "Paladin", nRow);
        Get2DACache("spells", "Ranger", nRow);
        Get2DACache("spells", "Wiz_Sorc", nRow);
        Get2DACache("spells", "Innate", nRow);
        Get2DACache("spells", "ConjTime", nRow);
        Get2DACache("spells", "ConjAnim", nRow);
        Get2DACache("spells", "ConjHeadVisual", nRow);
        Get2DACache("spells", "ConjHandVisual", nRow);
        Get2DACache("spells", "ConjGrndVisual", nRow);
        Get2DACache("spells", "ConjSoundVFX", nRow);
        Get2DACache("spells", "ConjSoundMale", nRow);
        Get2DACache("spells", "ConjSoundFemale", nRow);
        Get2DACache("spells", "CastAnim", nRow);
        Get2DACache("spells", "CastTime", nRow);
        Get2DACache("spells", "CastHeadVisual", nRow);
        Get2DACache("spells", "CastHandVisual", nRow);
        Get2DACache("spells", "CastGrndVisual", nRow);
        Get2DACache("spells", "CastSound", nRow);
        Get2DACache("spells", "Proj", nRow);
        Get2DACache("spells", "ProjModel", nRow);
        Get2DACache("spells", "ProjType", nRow);
        Get2DACache("spells", "ProjSpwnPoint", nRow);
        Get2DACache("spells", "ProjSound", nRow);
        Get2DACache("spells", "ProjOrientation", nRow);
        Get2DACache("spells", "ImmunityType", nRow);
        Get2DACache("spells", "ItemImmunity", nRow);
        Get2DACache("spells", "SubRadSpell1", nRow);
        Get2DACache("spells", "SubRadSpell2", nRow);
        Get2DACache("spells", "SubRadSpell3", nRow);
        Get2DACache("spells", "SubRadSpell4", nRow);
        Get2DACache("spells", "SubRadSpell5", nRow);
        Get2DACache("spells", "Category", nRow);
        Get2DACache("spells", "Master", nRow);
        Get2DACache("spells", "UserType", nRow);
        Get2DACache("spells", "SpellDesc", nRow);
        Get2DACache("spells", "UseConcentration", nRow);
        Get2DACache("spells", "SpontaneouslyCast", nRow);
        Get2DACache("spells", "AltMessage", nRow);
        Get2DACache("spells", "HostileSetting", nRow);
        Get2DACache("spells", "FeatID", nRow);
        Get2DACache("spells", "Counter1", nRow);
        Get2DACache("spells", "Counter2", nRow);
        Get2DACache("spells", "HasProjectile", nRow);
        nRow++;
        DelayCommand(0.01, Cache_Spells(nRow));
    }
    else
        DelayCommand(0.1, Cache_Feat());
    if(nRow % 100 == 0)
    {
        if(GetPRCSwitch(PRC_DB_SQLLITE))
        {
            string SQL = "COMMIT";
            PRC_SQLExecDirect(SQL);
            SQL = "BEGIN IMMEDIATE";
            PRC_SQLExecDirect(SQL);
        }
    }
}

void Cache_Portraits(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_portraits ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_PORTRAITS))
    {
        Get2DACache("portraits", "BaseResRef", nRow);
        Get2DACache("portraits", "Sex", nRow);
        Get2DACache("portraits", "Race", nRow);
        Get2DACache("portraits", "InanimateType", nRow);
        Get2DACache("portraits", "Plot", nRow);
        Get2DACache("portraits", "LowGore", nRow);
        nRow++;
        DelayCommand(0.1, Cache_Portraits(nRow));
    }
    else
        DelayCommand(1.0, Cache_Spells());
    if(nRow % 100 == 0)
    {
        if(GetPRCSwitch(PRC_DB_SQLLITE))
        {
            string SQL = "COMMIT";
            PRC_SQLExecDirect(SQL);
            SQL = "BEGIN IMMEDIATE";
            PRC_SQLExecDirect(SQL);
        }
    }
}

void Cache_Soundset(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_soundset ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_SOUNDSET))
    {
        Get2DACache("soundset", "LABEL", nRow);
        Get2DACache("soundset", "RESREF", nRow);
        Get2DACache("soundset", "STRREF", nRow);
        Get2DACache("soundset", "GENDER", nRow);
        Get2DACache("soundset", "TYPE", nRow);
        nRow++;
        DelayCommand(0.1, Cache_Soundset(nRow));
    }
    else
        DelayCommand(1.0, Cache_Portraits());
    if(nRow % 100 == 0)
    {
        if(GetPRCSwitch(PRC_DB_SQLLITE))
        {
            string SQL = "COMMIT";
            PRC_SQLExecDirect(SQL);
            SQL = "BEGIN IMMEDIATE";
            PRC_SQLExecDirect(SQL);
        }
    }
}

void Cache_Appearance(int nRow = 0)
{
    if(nRow == 0)
    {
        string SQL = "SELECT rowid FROM prc_cached2da_appearance ORDER BY rowid DESC LIMIT 1";
        PRC_SQLExecDirect(SQL);
        PRC_SQLFetch();
        nRow = StringToInt(PRC_SQLGetData(1))+1;
    }
    if(nRow < GetPRCSwitch(FILE_END_APPEARANCE))
    {
        Get2DACache("appearance", "LABEL", nRow);
        Get2DACache("appearance", "STRING_REF", nRow);
        Get2DACache("appearance", "NAME", nRow);
        Get2DACache("appearance", "RACE", nRow);
        Get2DACache("appearance", "ENVMAP", nRow);
        Get2DACache("appearance", "BLOODCOLR", nRow);
        Get2DACache("appearance", "MODELTYPE", nRow);
        Get2DACache("appearance", "WEAPONSCALE", nRow);
        Get2DACache("appearance", "WING_TAIL_SCALE", nRow);
        Get2DACache("appearance", "HELMET_SCALE_M", nRow);
        Get2DACache("appearance", "HELMET_SCALE_F", nRow);
        Get2DACache("appearance", "MOVERATE", nRow);
        Get2DACache("appearance", "WALKDIST", nRow);
        Get2DACache("appearance", "RUNDIST", nRow);
        Get2DACache("appearance", "PERSPACE", nRow);
        Get2DACache("appearance", "CREPERSPACE", nRow);
        Get2DACache("appearance", "HEIGHT", nRow);
        Get2DACache("appearance", "HITDIST", nRow);
        Get2DACache("appearance", "PREFATCKDIST", nRow);
        Get2DACache("appearance", "TARGETHEIGHT", nRow);
        Get2DACache("appearance", "ABORTONPARRY", nRow);
        Get2DACache("appearance", "RACIALTYPE", nRow);
        Get2DACache("appearance", "HASLEGS", nRow);
        Get2DACache("appearance", "HASARMS", nRow);
        Get2DACache("appearance", "PORTRAIT", nRow);
        Get2DACache("appearance", "SIZECATEGORY", nRow);
        Get2DACache("appearance", "PERCEPTIONDIST", nRow);
        Get2DACache("appearance", "FOOTSTEPTYPE", nRow);
        Get2DACache("appearance", "SOUNDAPPTYPE", nRow);
        Get2DACache("appearance", "HEADTRACK", nRow);
        Get2DACache("appearance", "HEAD_ARC_H", nRow);
        Get2DACache("appearance", "HEAD_ARC_V", nRow);
        Get2DACache("appearance", "HEAD_NAME", nRow);
        Get2DACache("appearance", "BODY_BAG", nRow);
        Get2DACache("appearance", "TARGETABLE", nRow);
        nRow++;
        DelayCommand(0.1, Cache_Appearance(nRow));
    }
    else
        DelayCommand(1.0, Cache_Soundset());
    if(nRow % 100 == 0)
    {
        if(GetPRCSwitch(PRC_DB_SQLLITE))
        {
            string SQL = "COMMIT";
            PRC_SQLExecDirect(SQL);
            SQL = "BEGIN IMMEDIATE";
            PRC_SQLExecDirect(SQL);
        }
    }
}

void Cache_2da_data()
{
    Cache_Appearance();
}