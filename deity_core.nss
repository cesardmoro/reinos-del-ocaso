///////////////////////////////////////////////////////////////////////////////
// deity_core.nss
//
// Created by: The Krit
// Date: 11/06/06
///////////////////////////////////////////////////////////////////////////////
//
// Core functions for pantheon implementation. Modify this file at your own
// risk!
//
// (If you don't know what you're doing, don't modify this file.)
//
///////////////////////////////////////////////////////////////////////////////
//
// To use: (for examples, see deity_onload.nss)
//
// Call AddDeity() for each deity in your world.
// The return value is an index into the list of deities.
// Note: Some feedback messages will appear odd if you add "" as a deity.
//
// Call SetDeityAlignment() to record the alignment of each deity, if needed.
// If this is not called, the default value is ALIGNMENT_ALL.
//
// Call SetDeityGender() to record each deity's gender, if needed.
// If this is not called, the default value is GENDER_NONE.
//
// Call AddClericAlignment() to set an alignment allowed for clerics of each
// deity. If this is not called, all alignments are allowed.
//
// Call AddClericDomain() to set an allowed domain for clerics of each deity.
// If this is not called, all domains are allowed.
// Note: If a deity has but one allowed domain, no PC can qualify as a cleric
// of that deity. If a deity has a duplicate in the list, a PC needs just that
// one domain to qualify.
//
// Call AddClericRace() to set a race allowed for clerics of each deity. If
// this is not called, all races are allowed.
//
// Call SetClericSubrace() to set the only subrace allowed for clerics of each
// deity. If this is not called, all subraces are allowed. If both this and
// AddClericRace are called, clerics must both have this subrace set and be
// one of the races specified.
//
// Call GetDeityIndex() instead of GetDeity() to get the index corresponding
// to a PC's deity.
//
// Call GetDeityName() to get the name corresponfing to an index.
//
// Call GetDeityAlignmentLC() to get a deity's law/chaos alignment.
//
// Call GetDeityAlignmentGE() to get a deity's good/evil alignment.
//
// Call GetDeityGender() to get a deity's gender.
//
// Call CheckClericAlignment() to see if a cleric meets the deity's alignment
// requirement.
//
// Call CheckClericDomains() to see if a cleric meets the deity's domain
// requirement.
//
// Call CheckClericRace() to see if a cleric meets the deity's race and
// subrace requirements.
//
// Call GetDeitySubrace() to get the subrace required of a deity's clerics.
//
// Call GetDeityCount() to get the number of deities in the pantheon.
//
// Call ShiftAlignmentTowardsDeity() to adjust a PC's alignment towards the
// PC's deity's alignment. Could be useful for rewards.
//
// Call StandardizeDeityName() for all the new PC's if you want to allow
// a somewhat more forgiving entry of deities at character creation.
// Specifically, case will not matter, and matching the first or last word(s)
// of a deity's name will be close enough. (Players wishing to follow a
// deity like "Solonor Thelandira" may appreciate this feature.)
//
///////////////////////////////////////////////////////////////////////////////
// NOTES:
//
// There is special handling for Lolth (in other files) that requires her
// clerics to be female. This requirement could be added in a generic fashion
// like the other cleric checks, but as long as there is but one special case,
// there is insufficient need to justify writing generic code.
///////////////////////////////////////////////////////////////////////////////

#include "prc_feat_const"

// Shorter names for the domains.
const int DOMAIN_AIR         = FEAT_AIR_DOMAIN_POWER;
const int DOMAIN_ANIMAL      = FEAT_ANIMAL_DOMAIN_POWER;
const int DOMAIN_DEATH       = FEAT_DEATH_DOMAIN_POWER;
const int DOMAIN_DESTRUCTION = FEAT_DESTRUCTION_DOMAIN_POWER;
const int DOMAIN_EARTH       = FEAT_EARTH_DOMAIN_POWER;
const int DOMAIN_EVIL        = FEAT_EVIL_DOMAIN_POWER;
const int DOMAIN_FIRE        = FEAT_FIRE_DOMAIN_POWER;
const int DOMAIN_GOOD        = FEAT_GOOD_DOMAIN_POWER;
const int DOMAIN_HEALING     = FEAT_HEALING_DOMAIN_POWER;
const int DOMAIN_KNOWLEDGE   = FEAT_KNOWLEDGE_DOMAIN_POWER;
const int DOMAIN_LUCK        = FEAT_LUCK_DOMAIN_POWER;
const int DOMAIN_MAGIC       = FEAT_MAGIC_DOMAIN_POWER;
const int DOMAIN_PLANT       = FEAT_PLANT_DOMAIN_POWER;
const int DOMAIN_PROTECTION  = FEAT_PROTECTION_DOMAIN_POWER;
const int DOMAIN_STRENGTH    = FEAT_STRENGTH_DOMAIN_POWER;
const int DOMAIN_SUN         = FEAT_SUN_DOMAIN_POWER;
const int DOMAIN_TRAVEL      = FEAT_TRAVEL_DOMAIN_POWER;
const int DOMAIN_TRICKERY    = FEAT_TRICKERY_DOMAIN_POWER;
const int DOMAIN_WAR         = FEAT_WAR_DOMAIN_POWER;
const int DOMAIN_WATER       = FEAT_WATER_DOMAIN_POWER;
// PRC Domains
const int DOMAIN_METAL       = FEAT_DOMAIN_POWER_METAL;
const int DOMAIN_STORM       = FEAT_DOMAIN_POWER_STORM;
const int DOMAIN_PORTAL      = FEAT_DOMAIN_POWER_PORTAL;
const int DOMAIN_DWARF       = FEAT_DOMAIN_POWER_DWARF;
const int DOMAIN_ORC         = FEAT_DOMAIN_POWER_ORC;
const int DOMAIN_FORCE       = FEAT_DOMAIN_POWER_FORCE;
const int DOMAIN_SLIME       = FEAT_DOMAIN_POWER_SLIME;
const int DOMAIN_TIME        = FEAT_DOMAIN_POWER_TIME;
const int DOMAIN_CHARM       = FEAT_DOMAIN_POWER_CHARM;
const int DOMAIN_SPELLS      = FEAT_DOMAIN_POWER_SPELLS;
const int DOMAIN_RUNE        = FEAT_DOMAIN_POWER_RUNE;
const int DOMAIN_FATE        = FEAT_DOMAIN_POWER_FATE;
const int DOMAIN_DOMINATION  = FEAT_DOMAIN_POWER_DOMINATION;
const int DOMAIN_UNDEATH     = FEAT_DOMAIN_POWER_UNDEATH;
const int DOMAIN_FAMILY      = FEAT_DOMAIN_POWER_FAMILY;
const int DOMAIN_HALFLING    = FEAT_DOMAIN_POWER_HALFLING;
const int DOMAIN_ILLUSION    = FEAT_DOMAIN_POWER_ILLUSION ;
const int DOMAIN_HATRED      = FEAT_DOMAIN_POWER_HATRED;
const int DOMAIN_NOBILITY    = FEAT_DOMAIN_POWER_NOBILITY;
const int DOMAIN_RETRIBUTION = FEAT_DOMAIN_POWER_RETRIBUTION;
const int DOMAIN_SCALEYKIND  = FEAT_DOMAIN_POWER_SCALEYKIND;
const int DOMAIN_GNOME       = FEAT_DOMAIN_POWER_GNOME;
const int DOMAIN_ELF         = FEAT_DOMAIN_POWER_ELF;
const int DOMAIN_RENEWAL     = FEAT_DOMAIN_POWER_RENEWAL;
const int DOMAIN_SPYDER      = FEAT_DOMAIN_POWER_SPIDER;
const int DOMAIN_TYRANNY     = FEAT_DOMAIN_POWER_TYRANNY;
const int DOMAIN_OCEAN       = FEAT_DOMAIN_POWER_OCEAN;
const int DOMAIN_BLIGHTBRINGER = FEAT_DOMAIN_POWER_BLIGHTBRINGER;

const int DOMAIN_DARKNESS    = FEAT_DOMAIN_POWER_DARKNESS;



// The names of module variables used to track the deities.
const string DEITY_COUNTER    = "TK_DEITY_COUNTER";
const string DEITY_NAME       = "TK_DEITY_NAME_";
const string DEITY_ALIGNMENT  = "TK_DEITY_PRIMARY_ALIGNMENT_";
const string DEITY_GENDER     = "TK_DEITY_GENDER_";
const string CLERIC_ALIGNMENT = "TK_DEITY_ALIGNMENTS_";
const string CLERIC_DOMAIN    = "TK_DEITY_DOMAINS_";
const string CLERIC_RACE      = "TK_DEITY_RACES_";
const string CLERIC_SUBRACE   = "TK_DEITY_SUBRACE_";


// Some utility functions.
string IntToFLString(int nInteger);
void ShiftAlignment(object oSubject, int nLawChaos, int nGoodEvil, int nAmount);

// Prototype needed for a particular hack.
void SetDeityGender(int nDeity, int nGender);


///////////////////////////////////////////////////////////////////////////////
// AddDeity()
//
// Adds sName as an accepted deity.
int AddDeity(string sName)
{
    // Get the index for the next deity entry.
    int nDeity = GetLocalInt(GetModule(), DEITY_COUNTER);
    // Store sName in the next slot.
    SetLocalString(GetModule(), DEITY_NAME + IntToHexString(nDeity), sName);
    // Record the new length of the deity list.
    SetLocalInt(GetModule(), DEITY_COUNTER, nDeity+1);

    // Hack to default the gender to be GENDER_NONE. (The normal default of 0 is GENDER_MALE.)
    SetDeityGender(nDeity, GENDER_NONE);

    // Return the index of this entry.
    return nDeity;
}


///////////////////////////////////////////////////////////////////////////////
// SetDeityAlignment()
//
// Records the alignment of deity nDeity.
// This is unique, unlike the allowed alignments of clerics.
//
// nDeity should be a return value of AddDeity(), and nLawChaos and nGoodEvil
// should be ALIGNMENT_* constants.
void SetDeityAlignment(int nDeity, int nLawChaos, int nGoodEvil)
{
    SetLocalInt(GetModule(), DEITY_ALIGNMENT + IntToHexString(nDeity) + "_LC", nLawChaos);
    SetLocalInt(GetModule(), DEITY_ALIGNMENT + IntToHexString(nDeity) + "_GE", nGoodEvil);
}


///////////////////////////////////////////////////////////////////////////////
// SetDeityGender()
//
// Records nGender as the gender of deity nDeity.
//
// nDeity should be a return value of AddDeity().
void SetDeityGender(int nDeity, int nGender)
{
    SetLocalInt(GetModule(), DEITY_GENDER + IntToHexString(nDeity), nGender);
}


///////////////////////////////////////////////////////////////////////////////
// AddClericAlignment()
//
// Adds nAlign as an allowed alignment of clerics of deity nDeity.
//
// nDeity should be a return value of AddDeity(), and nAlign should be one of
// the ALIGNMENT_* constants.
void AddClericAlignment(int nDeity, int nLawChaos, int nGoodEvil)
{
    // Add this alignment to the end of the list.
    SetLocalString(GetModule(), CLERIC_ALIGNMENT + IntToHexString(nDeity),
        GetLocalString(GetModule(), CLERIC_ALIGNMENT + IntToHexString(nDeity)) +
        IntToFLString(nLawChaos) + IntToFLString(nGoodEvil));
        // By using fixed-length strings, we get a built-in separator.
}


///////////////////////////////////////////////////////////////////////////////
// AddClericDomain()
//
// Adds nDomain as an allowed domain of clerics of deity nDeity.
//
// nDeity should be a return value of AddDeity(), and nDomain should be one of
// the FEAT_*_DOMAIN_POWER (or DOMAIN_*) constants.
//
// A deity will not be able to have any clerics if exactly one domain is added
// by this function.
void AddClericDomain(int nDeity, int nDomain)
{
    // Add nDomain to the end of the list.
    SetLocalString(GetModule(), CLERIC_DOMAIN + IntToHexString(nDeity),
        GetLocalString(GetModule(), CLERIC_DOMAIN + IntToHexString(nDeity)) +
        IntToFLString(nDomain));
        // By using fixed-length strings, we get a built-in separator.
}


///////////////////////////////////////////////////////////////////////////////
// AddClericRace()
//
// Adds nRace as an allowed race of clerics of deity nDeity.
//
// nDeity should be a return value of AddDeity(), and nRace should be one of
// the RACIAL_TYPE_* constants.
void AddClericRace(int nDeity, int nRace)
{
    // Add nRace to the end of the list.
    SetLocalString(GetModule(), CLERIC_RACE + IntToHexString(nDeity),
        GetLocalString(GetModule(), CLERIC_RACE + IntToHexString(nDeity)) +
        IntToFLString(nRace));
        // By using fixed-length strings, we get a built-in separator.
}


///////////////////////////////////////////////////////////////////////////////
// SetClericSubrace()
//
// Records sSubrace as the only allowed subrace of clerics of deity nDeity.
//
// nDeity should be a return value of AddDeity().
void SetClericSubrace(int nDeity, string sSubrace)
{
    SetLocalString(GetModule(), CLERIC_SUBRACE + IntToHexString(nDeity), sSubrace);
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityIndex()
//
// If oPC's deity was added by AddDeity, returns that deity's index.
//
// Returns -1 if the deity does not have an index (i.e. is not valid).
int GetDeityIndex(object oPC);
int GetDeityIndex(object oPC)
{
    string sName = GetDeity(oPC);
    int nNumDeities = GetLocalInt(GetModule(), DEITY_COUNTER);
    int nDeity = -1;

    // Loop through the known deities.
    while ( ++nDeity < nNumDeities )
        // Check for a match.
        if ( sName == GetLocalString(GetModule(), DEITY_NAME + IntToHexString(nDeity)) )
            // Return this index.
            return nDeity;

    // This deity was not found.
    return -1;
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityName()
//
// Returns the name of deity nDeity.
string GetDeityName(int nDeity)
{
    return GetLocalString(GetModule(), DEITY_NAME + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityAlignmentLC()
//
// Returns the law/chaos alignment of deity nDeity.
int GetDeityAlignmentLC(int nDeity)
{
    return GetLocalInt(GetModule(), DEITY_ALIGNMENT + IntToHexString(nDeity) + "_LC");
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityAlignmentGE()
//
// Returns the good/evil alignment of deity nDeity.
int GetDeityAlignmentGE(int nDeity);
int GetDeityAlignmentGE(int nDeity)
{
    return GetLocalInt(GetModule(), DEITY_ALIGNMENT + IntToHexString(nDeity) + "_GE");
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityGender()
//
// Returns the gender of deity nDeity.
int GetDeityGender(int nDeity)
{
    return GetLocalInt(GetModule(), DEITY_GENDER + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// CheckClericAlignment()
//
// Returns TRUE iff deity nDeity accepts clerics of oPC's alignment.
int CheckClericAlignment(object oPC, int nDeity);
int CheckClericAlignment(object oPC, int nDeity)
{
    // Get the list of accepted alignments.
    string sAlignments = GetLocalString(GetModule(), CLERIC_ALIGNMENT + IntToHexString(nDeity));

    // Check for universal acceptance.
    if ( sAlignments == "" )
        return TRUE;

    // Get the cleric's alignment.
    int nLawChaos = GetAlignmentLawChaos(oPC);
    int nGoodEvil = GetAlignmentGoodEvil(oPC);

    // Loop through the list of alignments.
    while ( sAlignments != "" )
    {
        // Check for a match.
        if ( nLawChaos == StringToInt(GetStringLeft(sAlignments, 10)) &&
             nGoodEvil == StringToInt(GetSubString(sAlignments, 10, 10)) )
            // This deity accepts this alignment.
            return TRUE;
        // Proceed to the next alignment. (Remove the leftmost 20 characters.)
        sAlignments = GetStringRight(sAlignments, GetStringLength(sAlignments)-20);
    }

    // If we get to this point, this alignment is not accepted by nDeity.
    return FALSE;
}


///////////////////////////////////////////////////////////////////////////////
// CheckClericDomains()
//
// Returns TRUE iff deity nDeity accepts clerics with oPC's domains.
//
// More precisely, returns TRUE iff the deity has no domain requirement or
// oPC possesses two domains from the deity's list. (If the list contains a
// duplicate, having that one duplicated domain will count as possessing two.)
int CheckClericDomains(object oPC, int nDeity);
int CheckClericDomains(object oPC, int nDeity)
{
    // Get the list of accepted domains.
    string sDomains = GetLocalString(GetModule(), CLERIC_DOMAIN + IntToHexString(nDeity));

    // Check for universal acceptance.
    if ( sDomains == "" )
        return TRUE;

    // Count of the number of listed domains possessed.
    int nCount = 0;

    // Loop through the list of domains.
    while ( sDomains != "" )
    {
        // Check for a match.
        if ( GetHasFeat(StringToInt(GetStringLeft(sDomains, 10)), oPC) )
            // Increase the count.
            nCount++;

        // Proceed to the next domain. (Remove the leftmost 10 characters.)
        sDomains = GetStringRight(sDomains, GetStringLength(sDomains)-10);
    }

    // We need (at least) two domains from the list to be accepted.
    return nCount > 1;
}


///////////////////////////////////////////////////////////////////////////////
// CheckClericRace()
//
// Returns TRUE iff deity nDeity accepts clerics of oPC's race.
//
// If the deity has a subrace specified, returns true if nDeity accepts oPC's
// race AND subrace. The subrace comparison is case-insensitive.
int CheckClericRace(object oPC, int nDeity)
{
    /* Chequeo de subraza desactivado por ahora
    // BEGIN SUBRACE CHECK.
    // Get the subrace requirement.
    string sSubrace = GetStringUpperCase(
                        GetLocalString(GetModule(),
                                       CLERIC_SUBRACE + IntToHexString(nDeity)) );
    // If a subrace is required.
    if ( sSubrace != "" )
        // If oPC's subrace does not match.
        if ( GetStringUpperCase(GetSubRace(oPC)) != sSubrace )
            // Wrong subrace; no need to check the race.
            return FALSE;
    // END SUBRACE CHECK.*/

    // Get the list of accepted races.
    string sRaces = GetLocalString(GetModule(), CLERIC_RACE + IntToHexString(nDeity));

    // Check for universal acceptance.
    if ( sRaces == "" )
        return TRUE;

    // Get the cleric's race.
    int nRace = GetRacialType(oPC);

    // Loop through the list of races.
    while ( sRaces != "" )
    {
        // Check for a match.
        if ( nRace == StringToInt(GetStringLeft(sRaces, 10)) )
            // This deity accepts this race.
            return TRUE;

        // Proceed to the next race. (Remove the leftmost 10 characters.)
        sRaces = GetStringRight(sRaces, GetStringLength(sRaces)-10);
    }

    // If we get to this point, this race is not accepted by nDeity.
    return FALSE;
}


///////////////////////////////////////////////////////////////////////////////
// GetClericSubrace()
//
// Returns the only allowed subrace of clerics of deity nDeity.
string GetClericSubrace(int nDeity)
{
    return GetLocalString(GetModule(), CLERIC_SUBRACE + IntToHexString(nDeity));
}


///////////////////////////////////////////////////////////////////////////////
// GetDeityCount()
//
// Returns the number of deities entered into the pantheon.
int GetDeityCount()
{
    return GetLocalInt(GetModule(), DEITY_COUNTER);
}


///////////////////////////////////////////////////////////////////////////////
// ShiftAlignmentTowardsDeity()
//
// Moves oPC's alignment towards oPC's deity's alignment by nAmount.
//
// The default for nAmount may be appropriate for tithing.
void ShiftAlignmentTowardsDeity(object oPC, int nAmount = 1)
{
    // Get oPC's deity's index.
    int nDeity = GetDeityIndex(oPC);

    // Abort if the deity is unknown.
    if ( nDeity < 0 )
        return;

    // Shift oPC towards the alignment stored for nDeity by SetDeityAlignment().
    ShiftAlignment(oPC,
        GetLocalInt(GetModule(), DEITY_ALIGNMENT + IntToHexString(nDeity) + "_LC"),
        GetLocalInt(GetModule(), DEITY_ALIGNMENT + IntToHexString(nDeity) + "_GE"),
        nAmount);
}


///////////////////////////////////////////////////////////////////////////////
// StandardizeDeityName()
//
// If oPC's deity field is a case-insensitive match to the beginning or end
// word(s) of a deity's name, this resets the deity field to the standard name.
//
// I am not checking for middle names because they are not that popular
// (non-existent, in fact, among the standard pantheon), and matching the middle
// word of something like "Thor of Olympus" seems strange.
//
// If there are multiple matches, only the first one counts. (Warn your players
// if your pantheon has re-used names.)
//
// Returns TRUE if a match is found.
int StandardizeDeityName(object oPC)
{
    string sName = GetStringUpperCase(GetDeity(oPC));
    string sMatch = "";
    int nLength = GetStringLength(sName) + 1;   // Add one for a space.
    int nNumDeities = GetLocalInt(GetModule(), DEITY_COUNTER);
    int nDeity = -1;


    // Loop through the known deities.
    while ( ++nDeity < nNumDeities )
    {
        // Get this deity's name.
        sMatch = GetStringUpperCase(
                    GetLocalString(GetModule(), DEITY_NAME + IntToHexString(nDeity)) );

        // Special handling for Selûne's special character.
        if ( sMatch == "SELûNE"  &&  sName == "SELUNE" )
            sName = sMatch;

        // Check for a match.
        if ( sName == sMatch  ||
             sName + " " == GetStringLeft(sMatch, nLength)  ||
             " " + sName == GetStringRight(sMatch, nLength) )
        {
            // Set oPC's deity to the standard name.
            SetDeity(oPC,
                GetLocalString(GetModule(), DEITY_NAME + IntToHexString(nDeity)) );

            // Return TRUE (found).
            return TRUE;
        }
    }

    // Return FALSE (not found).
    return FALSE;
}


///////////////////////////////////////////////////////////////////////////////
// UTILITIES
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// IntToFLString()
//
// Converts an integer to a Fixed-Length string.
//
// The length of the string returned is 10 characters, making this function
// roughly equivalent to IntToHexString, but the strings from this function
// can be converted back to integers by StringToInt().
string IntToFLString(int nInteger)
{
    string sInteger = "          ";     // 10 spaces for padding.
    sInteger += IntToString(nInteger);  // Convert to an over-long string.
    return GetStringRight(sInteger, 10);// Trim to 10 characters.
}


///////////////////////////////////////////////////////////////////////////////
// ShiftAlignment()
//
// Moves oSubject's alignment by nAmount, towards nLawChaos along the law/chaos
// axis, and towards nGoodEvil along the good/evil axis.
//
// Shifts towards neutrality ony affect oSubject if oSubject is not already
// neutral on that axis or if both shifts are towards neutrality.
//
// nLawChaos and nGoodEvil should be appropriate ALIGNMENT_* constants.
void ShiftAlignment(object oSubject, int nLawChaos, int nGoodEvil, int nAmount)
{
    // Check for neutral shifts. They need special handling.
    if ( nLawChaos == ALIGNMENT_NEUTRAL )
    {
        // Check for a full neutral shift. This doesn't need special handling.
        if ( nGoodEvil == ALIGNMENT_NEUTRAL )
        {
            // Do a full neutral shift and return.
            AdjustAlignment(oSubject, ALIGNMENT_NEUTRAL, nAmount);
            return;
        }

        // Instead of shifting to neutral on law/chaos, shift away from
        // oSubject's current alignment.
        // If oSubject is already neutral, do nothing.
        switch ( GetAlignmentLawChaos(oSubject) )
        {
            case ALIGNMENT_LAWFUL:  nLawChaos = ALIGNMENT_CHAOTIC; break;
            case ALIGNMENT_CHAOTIC: nLawChaos = ALIGNMENT_LAWFUL;  break;
        }
    }
    else if ( nGoodEvil == ALIGNMENT_NEUTRAL )
        // Instead of shifting to neutral on good/evil, shift away from
        // oSubject's current alignment.
        // If oSubject is already neutral, do nothing.
        switch ( GetAlignmentGoodEvil(oSubject) )
        {
            case ALIGNMENT_GOOD: nGoodEvil = ALIGNMENT_EVIL; break;
            case ALIGNMENT_EVIL: nGoodEvil = ALIGNMENT_GOOD; break;
        }

    // Call the standard library function for each axis, unless the shift is
    // still towards neutrality.
    if ( nLawChaos != ALIGNMENT_NEUTRAL )
        AdjustAlignment(oSubject, nLawChaos, nAmount);
    if ( nGoodEvil != ALIGNMENT_NEUTRAL )
        AdjustAlignment(oSubject, nGoodEvil, nAmount);
}

