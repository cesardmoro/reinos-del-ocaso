/*:://////////////////////////////////////////////
//:: Name Array functions
//:: FileName PHS_INC_Array
//:://////////////////////////////////////////////
    All array things:

    Informations got from spells.2da:

    - Spell Name (By Integer)
    - Spell Level (Integer, By seperate classes)
    - Spell Hostility (Integer)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Name of spells.2da.
const string PHS_SPELLS_2DA_NAME = "spells";
// 2da column names
const string PHS_SPELLS_2DA_COLUMN_NAME     = "Name";
const string PHS_SPELLS_2DA_COLUMN_BARD     = "Bard";
const string PHS_SPELLS_2DA_COLUMN_CLERIC   = "Cleric";
const string PHS_SPELLS_2DA_COLUMN_DRUID    = "Druid";
const string PHS_SPELLS_2DA_COLUMN_PALADIN  = "Paladin";
const string PHS_SPELLS_2DA_COLUMN_RANGER   = "Ranger";
const string PHS_SPELLS_2DA_COLUMN_WIZ_SORC = "Wiz_Sorc";
const string PHS_SPELLS_2DA_COLUMN_INNATE   = "Innate";
// Max entries in the 2da file to load up at start.
const int PHS_SPELLS_2DA_MAX_ENTRY = 1000;

// Gets the integer 2da value at nRow, for sColumn
int PHS_ArrayGetInteger(int nRow, string sColumn, object oModule);

// Gets the string 2da value at nRow, for sColumn
string PHS_ArrayGetString(int nRow, string sColumn, object oModule);

// Get the spell level associated with who cast the spell
// (EG: Mage level of Magic missile = 1)
int PHS_ArrayGetSpellLevel(int nSpellId, int nCasterClass, object oModule);

// Sets the integer 2da value at nRow, for sColumn
void PHS_ArraySetInteger(int nRow, string sColumn, object oModule);

// Sets the string 2da value at nRow, for sColumn
void PHS_ArraySetString(int nRow, string sColumn, object oModule);

// Sets all of the values in sColumn to oModule, as integers.
void PHS_ArraySetIntegerColumn(string sColumn, object oModule);

// Sets all of the values in sColumn to oModule, as strings.
void PHS_ArraySetStringColumn(string sColumn, object oModule);



// Gets the integer 2da value at nRow, for sColumn
int PHS_ArrayGetInteger(int nRow, string sColumn, object oModule)
{
    return GetLocalInt(oModule, sColumn + IntToString(nRow));
}

// Gets the string 2da value at nRow, for sColumn
string PHS_ArrayGetString(int nRow, string sColumn, object oModule)
{
    return GetLocalString(oModule, sColumn + IntToString(nRow));
}
// Get the spell level associated with who cast the spell
// (EG: Mage level of Magic missile = 1)
int PHS_ArrayGetSpellLevel(int nSpellId, int nCasterClass, object oModule)
{
    string sColumnName;
    switch(nCasterClass)
    {
        case CLASS_TYPE_BARD:       sColumnName = PHS_SPELLS_2DA_COLUMN_BARD; break;
        case CLASS_TYPE_CLERIC:     sColumnName = PHS_SPELLS_2DA_COLUMN_CLERIC; break;
        case CLASS_TYPE_DRUID:      sColumnName = PHS_SPELLS_2DA_COLUMN_DRUID; break;
        case CLASS_TYPE_PALADIN:    sColumnName = PHS_SPELLS_2DA_COLUMN_PALADIN; break;
        case CLASS_TYPE_RANGER:     sColumnName = PHS_SPELLS_2DA_COLUMN_RANGER; break;
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_WIZARD:
        {
            sColumnName = PHS_SPELLS_2DA_COLUMN_WIZ_SORC; break;
        }
        break;
        default: sColumnName = PHS_SPELLS_2DA_COLUMN_INNATE; break;
    }
    // Return value
    return PHS_ArrayGetInteger(nSpellId, sColumnName, oModule);
}

// Sets the integer 2da value at nRow, for sColumn
void PHS_ArraySetInteger(int nRow, string sColumn, object oModule)
{
    int nValue = StringToInt(Get2DAString(PHS_SPELLS_2DA_NAME, sColumn, nRow));
    SetLocalInt(oModule, sColumn + IntToString(nRow), nValue);
}

// Sets the string 2da value at nRow, for sColumn
void PHS_ArraySetString(int nRow, string sColumn, object oModule)
{
    string sValue = Get2DAString(PHS_SPELLS_2DA_NAME, sColumn, nRow);
    SetLocalString(oModule, sColumn + IntToString(nRow), sValue);
}

// Sets all of the values in sColumn to oModule, as integers.
void PHS_ArraySetIntegerColumn(string sColumn, object oModule)
{
    int nCnt;
    for(nCnt = 0; nCnt <= PHS_SPELLS_2DA_MAX_ENTRY; nCnt++)
    {
        PHS_ArraySetInteger(nCnt, sColumn, oModule);
    }
}
// Sets all of the values in sColumn to oModule, as strings.
void PHS_ArraySetStringColumn(string sColumn, object oModule)
{
    int nCnt;
    for(nCnt = 0; nCnt <= PHS_SPELLS_2DA_MAX_ENTRY; nCnt++)
    {
        PHS_ArraySetString(nCnt, sColumn, oModule);
    }
}
