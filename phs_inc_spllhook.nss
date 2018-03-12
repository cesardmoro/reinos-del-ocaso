/*:://////////////////////////////////////////////
//:: Spell Name Pre-spell hook
//:: Spell FileName phs_inc_spllhook
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    The call in this script is called before each spell.

    It can return TRUE or FALSE.

    You can either add things here, or use the Bioware method of executing
    scripts.

    Note: if this is edited, re-build a module to re-compile all scripts which
    call this function.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// - Contains the normal Use Magical Device checks
#include "PHS_INC_UMDCHECK"
// - Contains the pre-spell checks, such as Blinking
#include "PHS_INC_PRESPELL"
// Array things for names
#include "PHS_INC_ARRAY"

const int PHS_DESCRIPTOR_NONE           = 0;
const int PHS_DESCRIPTOR_ACID           = 1;
const int PHS_DESCRIPTOR_AIR            = 2;
const int PHS_DESCRIPTOR_CHAOTIC        = 3;
const int PHS_DESCRIPTOR_COLD           = 4;
const int PHS_DESCRIPTOR_DARKNESS       = 5;
const int PHS_DESCRIPTOR_DEATH          = 6;
const int PHS_DESCRIPTOR_EARTH          = 7;
const int PHS_DESCRIPTOR_ELECTRICITY    = 8;
const int PHS_DESCRIPTOR_EVIL           = 9;
const int PHS_DESCRIPTOR_FEAR           = 10;
const int PHS_DESCRIPTOR_FIRE           = 11;
const int PHS_DESCRIPTOR_FORCE          = 12;
const int PHS_DESCRIPTOR_GOOD           = 13;
const int PHS_DESCRIPTOR_LANGUAGE_DEPENDANT = 14;
const int PHS_DESCRIPTOR_LAWFUL         = 15;
const int PHS_DESCRIPTOR_LIGHT          = 16;
const int PHS_DESCRIPTOR_MIND_AFFECTING = 17;
const int PHS_DESCRIPTOR_SONIC          = 18;
const int PHS_DESCRIPTOR_WATER          = 19;

// SPELL HOOK FOR ALL PLAYER SPELLS
// Returns TRUE if they can cast the spell, FALSE means they cannot.
// * nSpellID - The spell ID of the spell.
//              If it is the default, -1, it will use GetSpellId();
int PHS_SpellHookCheck(int nSpellID = -1);

int PHS_SpellHookCheck(int nSpellID = -1)
{
/*
    // Declare things we may, or may not use.
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oSpellItem = GetSpellCastItem();
    object oArea = GetArea(oCaster);
    object oItem = GetSpellCastItem();
    object oModule = GetModule();
    int nCasterClass = GetLastSpellCastClass();
    string sName = GetStringByStrRef(PHS_ArrayGetInteger(nSpellID, PHS_SPELLS_2DA_COLUMN_NAME, oModule));
    int nSpellLevel = PHS_ArrayGetSpellLevel(nSpellID, nCasterClass, oModule);
    int nRoll;
    string sMessage;

    // Check nSpellID
    if(nSpellID <= -1)
    {
        nSpellID = GetSpellId();
    }
    // DEBUG MESSAGE
    SpeakString("Cast: " + sName + ". ID (Input): " + IntToString(nSpellID) + ". Target: " + GetName(oTarget) + ". Class: " + IntToString(nCasterClass));

    // Concentration for spells such as Black Blade of Disaster
    PHS_SpecialConcentrationChecks(oCaster);

    // Making sure they are not in time stop and casting spells against a target.
    if(GetIsObjectValid(oTarget) && oTarget != oCaster)
    {
        if(GetHasSpellEffect(PHS_SPELL_TIME_STOP, oCaster))
        {
            SendMessageToPC(oTarget, "You cannot cast spells against objects other then yourself in time stop");
            return FALSE;
        }
    }

    // Divine Focus check
    if(!PHS_DivineFocusCheck(sName))
    {
        return FALSE;
    }

    // Check use magical device
    if(!PHS_UMDCheck(sName, nSpellLevel, nSpellID))
    {
        return FALSE;
    }

    // Check breaking concentration incase normal hardcoded things where overriden
    if(!PHS_BreakConcentrationCheck(oSpellItem, oCaster))
    {
        return FALSE;
    }

    // Wild magic area + Effects.
    if(!PHS_WildMagicAreaSurge(oArea, oCaster))
    {
        return FALSE;
    }

    // Make sure Blink doesn't stop the spell from working (if it is a
    // single target spell!)
    if(GetIsObjectValid(oTarget))
    {
        // Blink check
        if(!PHS_BlinkCheck(oTarget, oCaster))
        {
            // Stop if the roll fails.
            return FALSE;
        }
    }
*/
    // Return TRUE if we can cast the spell
    return TRUE;
}
