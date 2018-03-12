//::///////////////////////////////////////////////
//:: Name      Spell Tracking Script
//:: FileName  av_spelltrack
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Include script for saving and restoring spell uses.

This is a bare-bones system which is NOT PERSISTENT over server restarts and
crashes, but could easily be converted to be so. A single parsed string stores
everything. Spells are saved on client leave and restored on client enter (just
include this script and call the appropriate functions). The strings are stored
as local data on the module and referenced by character ID (sID = Player Name +
Character Name). You must add this local string (sID) to each character on
enter before running the functions. You can also use the AVGetIsSpellCaster
function to bypass characters without spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Choirmaster
//:: Created On: 5/11/04
//:://////////////////////////////////////////////

int AVGetIsSpellCaster(object oPC)
{
    int nCount, nClass;
    for(nCount=1; nCount<=3; nCount++) {
        nClass = GetClassByPosition(nCount, oPC);
        //Paladins and Rangers don't have spells at low level, but it's not
        //really worth the effort adding the extra level check
        switch(nClass) {
            case CLASS_TYPE_BARD:
            case CLASS_TYPE_CLERIC:
            case CLASS_TYPE_DRUID:
            case CLASS_TYPE_PALADIN:
            case CLASS_TYPE_RANGER:
            case CLASS_TYPE_SORCERER:
            case CLASS_TYPE_WIZARD: return TRUE;
        }
    }
    return FALSE;
}

string AVRemoveStringToken(string sString, string sSep="|")
{
    int nPos=FindSubString(sString, sSep);

    if (nPos<0) return "";

    int nStrLen=GetStringLength(sString);
    nStrLen -= nPos + 1;
    return GetStringRight(sString, nStrLen);
}

string AVAddStringToken(string sString, string sTag, string sValue, string sSpacer="#", string sSep="|")
{
    if (sString=="") return sTag + sSpacer + sValue;
    return sString + sSep + sTag + sSpacer + sValue;
}

string AVGetStringToken(string sString, string sSep="|")
{
    int nPos = FindSubString(sString, sSep);
    if(nPos < 0) return sString;
    return GetStringLeft(sString, nPos);
}

int AVGetTokenIntTag(string sToken, string sSpacer="#")
{
    int nPos = FindSubString(sToken, sSpacer);
    return StringToInt(GetStringLeft(sToken, nPos));
}

int AVGetTokenIntValue(string sToken, string sSpacer="#")
{
    int nPos = FindSubString(sToken, sSpacer)+1;
    int nLength = GetStringLength(sToken);
    return StringToInt(GetSubString(sToken, nPos, nLength-nPos));
}

void AVSaveSpells(object oPC)
{
    object oMod = GetModule();
    string sID = GetName(oPC);
    string sSpells, sQty;

    int i;
    int nQty;
    //Loop through spells (epic spells and spell-like abilities don't register
    //and are tracked automatically, so stop at 549 (SPELL_GLYPH_OF_WARDING)
    for (i=0; i<550; i++) {
        nQty=GetHasSpell(i, oPC);
        if(nQty > 0) {
            sSpells = AVAddStringToken(sSpells, IntToString(i), IntToString(nQty));
        }
    }

    SetLocalString(oMod, "AVSS"+sID, sSpells);
    //for debugging
//    PrintString("Final parsed spell save string = "+sSpells);
}




