///////////////////////////////////////////////////////////////////////////////
// deity_include.nss
//
// Created by: The Krit
// Date: 11/06/06
///////////////////////////////////////////////////////////////////////////////
//
// This file includes deity_core and provides the means to store additional
// information about the deities of your module. If needed, add functions
// using the templates provided below.
//
// None of the functions in this file are needed for the core functionality
// of this deity system. Most of the examples provided are used in either the
// example conversation or the example scipts (deity_example.nss). A few are
// here just because they seemed like a good idea at the time. Add and delete
// functions to suit your needs.
//
///////////////////////////////////////////////////////////////////////////////
//
// Current examples:
//
// Call SetDeityAvatar() to record the creature that serves as the avatar of
// each deity, if needed. If this is not called, the default value is
// OBJECT_INVALID.
//
// Call SetDeityHolySymbol() to record the blueprint name for the holy symbol
// of each deity, if needed. If this is not called, the default value is "".
//
// Call SetDeityPortfolio() to record the portfolio of each deity, if needed.
// If this is not called, the default value is "".
//
// Call SetDeitySpawnLoc() to set the tag of the spawn location for followers
// of each deity, if needed. If this is not called, the default value is "".
//
// Call SetDeityTitle() to record each deity's title, if needed. If this is
// not called, the default value is "".
//
// Call SetDeityTitleAlternates() to record each deity's additional titles,
// if needed. If this is not called, the default value is "".
//
// Call SetDeityWeapon() to record each deity's preferred weapon, if needed.
// If this is not called, the default value is BASE_ITEM_SHORTSWORD.
//
// Call GetDeityAvatar() to retrieve the avatar (creature) of a deity.
//
// Call GetDeityHolySymbol() to retrieve the blueprint for a deity's holy symbol.
//
// Call GetDeityPortfolio() to retrieve a deity's portfolio.
//
// Call GetDeitySpawnLoc() to retrieve the tag of the spawn location for
// followers of a deity.
//
// Call GetDeitySpawnLocator() to retrieve an object at the spawn location for
// followers of a deity.
//
// Call GetDeityTitle() to retrieve a deity's title.
//
// Call GetDeityTitleAlternates() to retrieve a deity's additional titles,
//
// Call GetDeityWeapon() to retrieve a deity's preferred weapon, as a
// BASE_ITEM_* constant.
//
///////////////////////////////////////////////////////////////////////////////
//
// Creating new functions:
//
// Here are function templates that can be used. In each template, replace the
// @ character with a suitable word to describe the data. You will also need
// to add a line like
// const string DEITY_@  = "TK_DEITY_@_";
// to the list of variable names.
// For consistency, match the capitalization of the examples. (Capitalize the
// replacement for @ most of the time, but use ALL CAPS for "DEITY_@".)
// Some variations are possible, if you know your scripting well enough.

/* TEMPLATE: Setting string data *
///////////////////////////////////////////////////////////////////////////////
// Call SetDeity@()
//
// Records s@ as the @ of deity nDeity.
//
// nDeity should be a return value of AddDeity().
void SetDeity@(int nDeity, string s@)
{
    SetLocalString(GetModule(), DEITY_@ + IntToHexString(nDeity), s@);
}
*/

/* TEMPLATE: Retrieving string data *
///////////////////////////////////////////////////////////////////////////////
// GetDeity@()
//
// Returns the @ of deity nDeity.
string GetDeity@(int nDeity)
{
    return GetLocalString(GetModule(), DEITY_@ + IntToHexString(nDeity));
}
*/

/* TEMPLATE: Setting integer data *
///////////////////////////////////////////////////////////////////////////////
// Call SetDeity@()
//
// Records s@ as the @ of deity nDeity.
//
// nDeity should be a return value of AddDeity().
void SetDeity@(int nDeity, int n@)
{
    SetLocalInt(GetModule(), DEITY_@ + IntToHexString(nDeity), n@);
}
*/

/* TEMPLATE: Retrieving integer data *
///////////////////////////////////////////////////////////////////////////////
// GetDeity@()
//
// Returns the @ of deity nDeity.
int GetDeity@(int nDeity)
{
    return GetLocalInt(GetModule(), DEITY_@ + IntToHexString(nDeity));
}
*/

///////////////////////////////////////////////////////////////////////////////
// And now, onto the actual code.
///////////////////////////////////////////////////////////////////////////////


// Include the core functions and constants.
#include "deity_core"


// The names of module variables used to track the deities.
// For reference, the constants in deity_core are:
//   const string DEITY_COUNTER    = "TK_DEITY_COUNTER";
//   const string DEITY_NAME       = "TK_DEITY_NAME_";
//   const string DEITY_ALIGNMENT  = "TK_DEITY_PRIMARY_ALIGNMENT_";
//   const string DEITY_GENDER     = "TK_DEITY_GENDER_";
//   const string CLERIC_ALIGNMENT = "TK_DEITY_ALIGNMENTS_";
//   const string CLERIC_DOMAIN    = "TK_DEITY_DOMAINS_";
//   const string CLERIC_RACE      = "TK_DEITY_RACES_";
//   const string CLERIC_SUBRACE   = "TK_DEITY_SUBRACE_";
// Avoid using the same variable name twice. (That's both module and script
// variable names.)
const string DEITY_AVATAR      = "TK_DEITY_AVATAR_";
const string DEITY_PORTFOLIO   = "TK_DEITY_PORTFOLIO_";
const string DEITY_SPAWN       = "TK_DEITY_SPAWN_LOC_";
const string DEITY_SPAWNMARKER = "TK_DEITY_SPAWN_LOCATOR_";
const string DEITY_SYMBOL      = "TK_DEITY_SYMBOL_";     // A cleric's holy symbol.
const string DEITY_BOOK       = "TK_DEITY_BOOK_";
const string DEITY_TITLE       = "TK_DEITY_TITLE_";
const string DEITY_TITLEAKA    = "TK_DEITY_TITLE_AKA_";  // Alternate titles.
const string DEITY_WEAPON      = "TK_DEITY_WEAPON_";


///////////////////////////////////////////////////////////////////////////////
// SetDeityAvatar()
//
// Records the creature serving as the avatar of deity nDeity.
//
// sTag should be the tag of the creature.
//
// nDeity should be a return value of AddDeity().
//
// The creature is determined when this function is called.
//
// I'm not sure if this function is actually useful. I really just wanted an
// example function that stored an object, even though non-scripters probably
// don't want to bother with such things.
void SetDeityAvatar(int nDeity, string sTag);
void SetDeityAvatar(int nDeity, string sTag)
{
    SetLocalObject(GetModule(), DEITY_AVATAR + IntToHexString(nDeity),
                   GetObjectByTag(sTag));
}


///////////////////////////////////////////////////////////////////////////////
// SetDeityHolySymbol()
//
// Records sBlueprint as the holy symbol of deity nDeity.
//
// nDeity should be a return value of AddDeity().
//
// The tag of each holy symbol must be "HolySymbol" to work with this system.
// This should make it HCR friendly automatically :)
void SetDeityHolySymbol(int nDeity, string sBlueprint);
void SetDeityHolySymbol(int nDeity, string sBlueprint)
{
    SetLocalString(GetModule(), DEITY_SYMBOL + IntToHexString(nDeity), sBlueprint);
}


///////////////////////////////////////////////////////////////////////////////
// SetDeityPortfolio()
//
// Records sSpecialty as the portfolio of deity nDeity.
//
// nDeity should be a return value of AddDeity().
void SetDeityPortfolio(int nDeity, string sSpecialty);
void SetDeityPortfolio(int nDeity, string sSpecialty)
{
    SetLocalString(GetModule(), DEITY_PORTFOLIO + IntToHexString(nDeity), sSpecialty);
}


///////////////////////////////////////////////////////////////////////////////
// SetDeitySpawnLoc()
//
// Records the tag of the spawn location for followers of deity nDeity.
//
// Also records an object with that tag. This is more efficient if you're
// writing your own scripts. (Some existing scripts expect a string.)
//
// sTag should be the tag of an object (probably a waypoint) whose location
// is the spawn location.
//
// nDeity should be a return value of AddDeity().
void SetDeitySpawnLoc(int nDeity, string sTag);
void SetDeitySpawnLoc(int nDeity, string sTag)
{
    SetLocalString(GetModule(), DEITY_SPAWN + IntToHexString(nDeity), sTag);
    SetLocalObject(GetModule(), DEITY_SPAWNMARKER + IntToHexString(nDeity),
                   GetObjectByTag(sTag));
}


///////////////////////////////////////////////////////////////////////////////
// SetDeityBook()
//
// Nota por Dragoncin:
// Originalmente esta funcion guardaba una frase tipo "por los dioses!"
// Ahora guarda el ResRef del libro del dios.
//
// nDeity should be a return value of AddDeity().
void SetDeityBook(int nDeity, string sBook);
void SetDeityBook(int nDeity, string sBook)
{
    SetLocalString(GetModule(), DEITY_BOOK + IntToHexString(nDeity), sBook);
}


///////////////////////////////////////////////////////////////////////////////
// SetDeityTitle()
//
// Records sTitle as the title of deity nDeity.
//
// nDeity should be a return value of AddDeity().
void SetDeityTitle(int nDeity, string sTitle);
void SetDeityTitle(int nDeity, string sTitle)
{
    SetLocalString(GetModule(), DEITY_TITLE + IntToHexString(nDeity), sTitle);
}


///////////////////////////////////////////////////////////////////////////////
// SetDeityTitleAlternates()
//
// Records sTitles as the alternate titles of deity nDeity.
//
// nDeity should be a return value of AddDeity().
void SetDeityTitleAlternates(int nDeity, string sTitles);
void SetDeityTitleAlternates(int nDeity, string sTitles)
{
    SetLocalString(GetModule(), DEITY_TITLEAKA + IntToHexString(nDeity), sTitles);
}


///////////////////////////////////////////////////////////////////////////////
// SetDeityWeapon()
//
// Records nWeapon as (the base item of) the favored weapon of deity nDeity.
//
// nDeity should be a return value of AddDeity().
void SetDeityWeapon(int nDeity, int nWeapon);
void SetDeityWeapon(int nDeity, int nWeapon)
{
    SetLocalInt(GetModule(), DEITY_WEAPON + IntToHexString(nDeity), nWeapon);
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityAvatar()
//
// Returns the creature serving as the avatar of deity nDeity.
//
// I'm not sure if this function is actually useful. I really just wanted an
// example function that stored an object, even though non-scripters probably
// don't want to bother with such things.
object GetDeityAvatar(int nDeity);
object GetDeityAvatar(int nDeity)
{
    return GetLocalObject(GetModule(), DEITY_AVATAR + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityHolySymbol()
//
// Returns the blueprint of the holy symbol of deity nDeity.
string GetDeityHolySymbol(int nDeity);
string GetDeityHolySymbol(int nDeity)
{
    return GetLocalString(GetModule(), DEITY_SYMBOL + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityPortfolio()
//
// Returns the portfolio of deity nDeity.
string GetDeityPortfolio(int nDeity);
string GetDeityPortfolio(int nDeity)
{
    return GetLocalString(GetModule(), DEITY_PORTFOLIO + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeitySpawnLoc()
//
// Returns the tag of the spawn location for followers of deity nDeity.
//
// To get from the tag (sTag) to the location (lLoc) in another script, use
// something like:
//    object oTarget = GetObjectByTag(sTag);
//    // Check for a valid object marking the spawn location.
//    if ( GetIsObjectValid(oTarget)  &&  GetIsObjectValid(GetAreaFromLocation(GetLocation(oTarget))) )
//        lLoc = GetLocation(oTarget);
//    else
//       lLoc = <default value, whatever you decide it shoud be>
string GetDeitySpawnLoc(int nDeity);
string GetDeitySpawnLoc(int nDeity)
{
    return GetLocalString(GetModule(), DEITY_SPAWN + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeitySpawnLocator()
//
// Returns the object marking the spawn location for followers of deity nDeity.
// (Not the location because it's much easier to test for an invalid object
// than an invalid location, and getting the location from an object is not
// processor-intensive.)
//
// To get from the object (oTarget) to the location (lLoc) in another script,
// and you are careful not to cause your location markers to get invalid
// locations, use something like:
//    // Check for a valid object marking the spawn location.
//    if ( GetIsObjectValid(oTarget) )
//        lLoc = GetLocation(oTarget);
//    else
//       lLoc = <default value, whatever you decide it shoud be>
object GetDeitySpawnLocator(int nDeity);
object GetDeitySpawnLocator(int nDeity)
{
    return GetLocalObject(GetModule(), DEITY_SPAWNMARKER + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityBookr()
//
// Nota por Dragoncin:
// Originalmente esta funcion devolvia una frase tipo "por los dioses!"
// Ahora devuelve el ResRef del libro del dios.
//
string GetDeityBook(int nDeity);
string GetDeityBook(int nDeity)
{
    return GetLocalString(GetModule(), DEITY_BOOK + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityTitle()
//
// Returns the title of deity nDeity.
string GetDeityTitle(int nDeity);
string GetDeityTitle(int nDeity)
{
    return GetLocalString(GetModule(), DEITY_TITLE + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityTitleAlternates()
//
// Returns the alternate titles of deity nDeity.
string GetDeityTitleAlternates(int nDeity);
string GetDeityTitleAlternates(int nDeity)
{
    return GetLocalString(GetModule(), DEITY_TITLEAKA + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityWeapon()
//
// Returns the favored weapon of deity nDeity as a BASE_ITEM_* constant.
int GetDeityWeapon(int nDeity);
int GetDeityWeapon(int nDeity)
{
    return GetLocalInt(GetModule(), DEITY_WEAPON + IntToHexString(nDeity));
}

