///////////////////////////////////////////////////////////////////////////////
// deityconv_inc.nss
//
// Created by: The Krit
// Date: 11/08/06
///////////////////////////////////////////////////////////////////////////////
//
// This file is used by the sample conversation (deity_list) that describes the
// pantheon of this module. The conversation and its associated scripts (all
// of whose names begin with "deityconv_") are intended as a starting point
// and an example, but could also be used as-is.
//
// (Some general advice: if you intend to modify the conversation or scripts,
// make copies so you have a reference in case you get lost.)
//
///////////////////////////////////////////////////////////////////////////////
//
// Call SetupDeityConversationTokens() in the middle of a conversation to
// define tokens used to talk about the deities.
//
// Call SetupDeityListTokens() in the middle of a conversation to define
// tokens used to list the deities a PC could reasonably follow.
//
///////////////////////////////////////////////////////////////////////////////
//
// Uses custom tokens #420 through 429 and 430 through 436.
//
//  CUSTOM420 is the deity's name.
//  CUSTOM421 is "He" or "She" (or name), based on the deity's gender.
//  CUSTOM422 is the deity's alignment.
//  CUSTOM423 is " of " + the deity's portfolio (or empty).
//  CUSTOM424 is the deity's title (or "god", "goddess", or "deity").
//  CUSTOM425 is ", also known as " + the deity's alternate titles (or empty).
//  CUSTOM426 is " " + allowed alignments (or empty).
//  CUSTOM427 is the list of allowed domains.
//  CUSTOM428 is " " + allowed races (or empty)  (or " and" if no races but both alignments and subraces).
//  CUSTOM429 is " of the " + required subrace + " subrace" (or empty).
//
//  CUSTOM430 through CUSTOM436 hold deity names.
//  This range (430 through 436) can be changed via the following lines:
const int TOKENLIST_START = 430;
const int TOKENLIST_LENGTH = 7;
//
///////////////////////////////////////////////////////////////////////////////


// Includes.
#include "deity_include"

// Prototypes.
string AlignmentToString(int nLawChaos, int nGoodEvil);
string DomainToString(int nDomain);
string RaceToString(int nRace);
string ListToStringAlign(string sList);
string ListToStringDomain(string sList);
string ListToStringRace(string sList);



///////////////////////////////////////////////////////////////////////////////
// SetupDeityConversationTokens()
//
// Defines tokens to allow conversations to refer to the deities.
void SetupDeityConversationTokens(int nDeity)
{
    string sToken = ""; // Used to build each token string. (Adds readability.)
    int bLolth = FALSE; // Used to flag Lolth's special handling.

    // Token 420 is the deity's name.
    sToken = GetDeityName(nDeity);
    // Flag Lolth.
    bLolth = (sToken == "Lolth");
    // Set the token.
    SetCustomToken(420, sToken);

    //Mod by drago. Menos llamadas a la funcion (en espaniol se usan mas los generos).
    int iDeityGender = GetDeityGender(nDeity);

    // Token 421 is "He" or "She" (or name), based on the deity's gender.
    switch ( iDeityGender )
    {
        case GENDER_MALE:   sToken = "El";  break;
        case GENDER_FEMALE: sToken = "Ella"; break;
        default:            sToken = GetDeityName(nDeity);  break;
    }
    // Set the token.
    SetCustomToken(421, sToken);

    // Token 422 is the deity's alignment.
    sToken = AlignmentToString(GetDeityAlignmentLC(nDeity), GetDeityAlignmentGE(nDeity));
    // Set the token.
    SetCustomToken(422, sToken);

    // Token 423 is " of " + the deity's portfolio (or empty).
    sToken = GetDeityPortfolio(nDeity);
    if ( sToken != "" )
        sToken = " de " + sToken;
    // Set the token.
    SetCustomToken(423, sToken);

    // Token 424 is the deity's title (or "god", "goddess", or "deity").
    sToken = GetDeityTitle(nDeity);
    // See if a default title is needed.
    if ( sToken == "" )
        switch ( iDeityGender )
        {
            case GENDER_FEMALE: sToken = "la diosa"; break;
            case GENDER_MALE:   sToken = "el dios";     break;
            default:            sToken = "la deidad";   break;
        }
    // Set the token.
    SetCustomToken(424, sToken);

    // Token 425 ", also known as " + the deity's alternate titles + "," (or empty).
    sToken = GetDeityTitleAlternates(nDeity);
    // Check that the deity has alternate titles.
    if ( sToken != "" )
        switch ( iDeityGender )
        {
            case GENDER_MALE:   sToken = ", tambien conocido como " + sToken;   break;
            default:            sToken = ", tambien conocida como " + sToken;   break;
        }
    // Set the token.
    SetCustomToken(425, sToken);

    // Token 426 is " " + allowed alignments (or empty).
    sToken = ListToStringAlign(
        GetLocalString(GetModule(), CLERIC_ALIGNMENT + IntToHexString(nDeity)));
    // Add the space if not an empty string.
    if ( sToken != "" )
        sToken = " " + sToken;
    // Set the token.
    SetCustomToken(426, sToken);

    // Token 427 is the list of allowed domains.
    sToken = ListToStringDomain(
        GetLocalString(GetModule(), CLERIC_DOMAIN + IntToHexString(nDeity)));
    // Set the token.
    SetCustomToken(427, sToken);

    // Token 428 is " " + allowed races (or empty) (or " and" if no races but both alignments and subraces).
    sToken = ListToStringRace(
                GetLocalString(GetModule(), CLERIC_RACE + IntToHexString(nDeity)));
    // Add the space if not an empty string.
    if ( sToken != "" )
        sToken = " " + sToken;
    // SPECIAL: If deity is Lolth, do not set an empty string...
    else if ( bLolth )
        // ... set "s" instead.
        sToken = "s";
    // If there are alignment and subrace requirements, do not set an empty string...
    else if ( "" != GetLocalString(GetModule(), CLERIC_DOMAIN + IntToHexString(nDeity))
              &&  "" != GetClericSubrace(nDeity) )
        /// ... set " and" instead.
        sToken = " y";
    // SPECIAL: If deity is Lolth, insert " female".
    if ( bLolth )
        sToken = " hembra" + sToken;
    // Set the token.
    SetCustomToken(428, sToken);

    // Token 429 is " of the " + required subrace + " subrace" (or empty).
    sToken = GetClericSubrace(nDeity);
    // Add the text if not an empty string.
    if ( sToken != "" )
        sToken = " de la subraza" + sToken;
    // Set the token.
    SetCustomToken(429, sToken);
}


///////////////////////////////////////////////////////////////////////////////
// SetupDeityListTokens()
//
// Defines the list of deities that oPC can follow, and defines conversation
// tokens for the first six or seven.
//
// This will list "Lolth" for male non-clerics, even though they cannot be her
// clerics. Otherwise, for non-clerics, "can follow" means "meets all clerical
// requirements but domains". For clerics, it means "meets all clerical
// requirements".
void SetupDeityListTokens(object oPC)
{
    int nTotalDeities = GetDeityCount();    // Size of pantheon.
    int nDeity = 0;             // The current deity being checked.
    int nListedDeities = 0;     // The number of deities to list.
    int bAccept = FALSE;        // To simplify the coding of acceptance conditions.

    // Loop through the pantheon.
    while ( nDeity < nTotalDeities )
    {
        // Check nDeity's acceptance of oPC's alignment and race.
        bAccept = CheckClericAlignment(oPC, nDeity)  &&  CheckClericRace(oPC, nDeity);

        // If oPC is a cleric, perform additional checks.
        if ( bAccept  &&  GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 )
            // Clerics need to have the right domains.
            bAccept = CheckClericDomains(oPC, nDeity)  &&
                      // Special gender check for Lolth.
                      ( GetDeityName(nDeity) != "Lolth"  ||  GetGender(oPC) == GENDER_FEMALE );

        // Is oPC accepted?
        if ( bAccept )
        {
            // Record this deity in the list.
            SetLocalInt(OBJECT_SELF, "DeityList_" + IntToString(nListedDeities),
                        nDeity);
            // Record this deity's name in a token, if more are left.
            if ( nListedDeities < TOKENLIST_LENGTH )
                SetCustomToken(TOKENLIST_START + nListedDeities, GetDeityName(nDeity));
            // Increment the count.
            nListedDeities++;
        }

        // Next deity.
        nDeity++;
    }

    // Record the beginning of the list for this batch of tokens.
    SetLocalInt(OBJECT_SELF, "DeityList_Begin", 0);
    // Record the length of the list.
    SetLocalInt(OBJECT_SELF, "DeityList_Count", nListedDeities);
    // Record the number of tokens with data.
    if ( nListedDeities <= TOKENLIST_LENGTH )
        SetLocalInt(OBJECT_SELF, "DeityList_LastToken", nListedDeities);
    else
        // Subtract one to make room for the "More" option.
        SetLocalInt(OBJECT_SELF, "DeityList_LastToken", TOKENLIST_LENGTH - 1);

    // Empty any remaining tokens (just in case they show up somewhere).
    while ( nListedDeities < TOKENLIST_LENGTH )
        SetCustomToken(TOKENLIST_START + nListedDeities++, "");
}


///////////////////////////////////////////////////////////////////////////////
// ContinueDeityListTokens()
//
// Defines conversation tokens for the next six or seven deities that the PC
// speaker can follow.
void ContinueDeityListTokens()
{
    int nStartEntry = GetLocalInt(OBJECT_SELF, "DeityList_Begin") +
                      GetLocalInt(OBJECT_SELF, "DeityList_LastToken");
    int nStopToken = GetLocalInt(OBJECT_SELF, "DeityList_Count") - nStartEntry;
    int nCurrentToken = 0;

    // Cap the stop token.
    if ( nStopToken > TOKENLIST_LENGTH )
        nStopToken = TOKENLIST_LENGTH - 1;
        // Subtract one to make room for the "More" option.

    // Loop through the list.
    while ( nCurrentToken < nStopToken )
    {
        // Record the next deity's name in a token.
        SetCustomToken(TOKENLIST_START + nCurrentToken, GetDeityName(
            GetLocalInt(OBJECT_SELF, "DeityList_" + IntToString(nStartEntry + nCurrentToken)) ));

        // Next token.
        nCurrentToken++;
    }

    // Record the beginning of the list for this batch of tokens.
    SetLocalInt(OBJECT_SELF, "DeityList_Begin", nStartEntry);
    // Record the number of tokens with data.
    SetLocalInt(OBJECT_SELF, "DeityList_LastToken", nStopToken);

    // Empty any remaining tokens (just in case they show up somewhere).
    while ( nCurrentToken < TOKENLIST_LENGTH )
        SetCustomToken(TOKENLIST_START + nCurrentToken++, "");
}


///////////////////////////////////////////////////////////////////////////////
// BackupDeityListTokens()
//
// Defines conversation tokens for the previous six or seven deities that the PC
// speaker can follow.
void BackupDeityListTokens()
{
    int nStartEntry = GetLocalInt(OBJECT_SELF, "DeityList_Begin") - (TOKENLIST_LENGTH - 1);
    // One was subtracted to make room for the "More" option.
    // Don't start negative.
    if ( nStartEntry < 0 )
        nStartEntry = 0;

    int nStopToken = GetLocalInt(OBJECT_SELF, "DeityList_Count") - nStartEntry;
    int nCurrentToken = 0;

    // Cap the stop token.
    if ( nStopToken > TOKENLIST_LENGTH )
        nStopToken = TOKENLIST_LENGTH - 1;
        // Subtract one to make room for the "More" option.

    // Loop through the list.
    while ( nCurrentToken < nStopToken )
    {
        // Record the next deity's name in a token.
        SetCustomToken(TOKENLIST_START + nCurrentToken, GetDeityName(
            GetLocalInt(OBJECT_SELF, "DeityList_" + IntToString(nStartEntry + nCurrentToken)) ));

        // Next token.
        nCurrentToken++;
    }

    // Record the beginning of the list for this batch of tokens.
    SetLocalInt(OBJECT_SELF, "DeityList_Begin", nStartEntry);
    // Record the number of tokens with data.
    SetLocalInt(OBJECT_SELF, "DeityList_LastToken", nStopToken);

    // Empty any remaining tokens (just in case they show up somewhere).
    while ( nCurrentToken < TOKENLIST_LENGTH )
        SetCustomToken(TOKENLIST_START + nCurrentToken++, "");
}


///////////////////////////////////////////////////////////////////////////////
// UTILITIES
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// AlignmentToString()
//
// Converts an alignment pair to a string description.
//
// Invalid input is treated as ALIGNMENT_NEUTRAL.
//
// Note: When I last checked, 0 was the definition of ALIGNMENT_ALL.
string AlignmentToString(int nLawChaos, int nGoodEvil)
{
    string sAlignment = "";

    // Start with the law/chaos descriptor.
    switch ( nLawChaos )
    {
        case ALIGNMENT_LAWFUL:  sAlignment = "legales-";  break;
        case ALIGNMENT_CHAOTIC: sAlignment = "caoticos-"; break;
        default:                sAlignment = "neutrales-";
    }

    // Add the good/evil descriptor.
    switch ( nGoodEvil )
    {
        case ALIGNMENT_GOOD: sAlignment += "buenos";  break;
        case ALIGNMENT_EVIL: sAlignment += "malvados"; break;
        default:             sAlignment += "neutrales";
    }

    // Change "neutral-neutral" to "true neutral".
    if ( sAlignment == "neutrales-neutrales" )
        sAlignment = "neutrales verdaderos";

    // Done.
    return sAlignment;
}


///////////////////////////////////////////////////////////////////////////////
// DomainToString()
//
// Converts a domain code to a string description.
//
// Invalid input results in "unknown".
string DomainToString(int nDomain)
{
    string sDomain = "";    // The returned string. For readability.

    switch ( nDomain )
    {
        case DOMAIN_AIR:         sDomain = "aire";         break;
        case DOMAIN_ANIMAL:      sDomain = "animal";      break;
        case DOMAIN_DEATH:       sDomain = "muerte";       break;
        case DOMAIN_DESTRUCTION: sDomain = "destruccion"; break;
        case DOMAIN_EARTH:       sDomain = "tierra";       break;
        case DOMAIN_EVIL:        sDomain = "mal";        break;
        case DOMAIN_FIRE:        sDomain = "fuego";        break;
        case DOMAIN_GOOD:        sDomain = "bien";        break;
        case DOMAIN_HEALING:     sDomain = "curacion";     break;
        case DOMAIN_KNOWLEDGE:   sDomain = "conocimiento";   break;
        case DOMAIN_LUCK:        sDomain = "suerte";        break;
        case DOMAIN_MAGIC:       sDomain = "magia";       break;
        case DOMAIN_PLANT:       sDomain = "vegetal";       break;
        case DOMAIN_PROTECTION:  sDomain = "proteccion";  break;
        case DOMAIN_STRENGTH:    sDomain = "fuerza";    break;
        case DOMAIN_SUN:         sDomain = "sol";         break;
        case DOMAIN_TRAVEL:      sDomain = "viaje";      break;
        case DOMAIN_TRICKERY:    sDomain = "supercheria";    break;
        case DOMAIN_WAR:         sDomain = "guerra";         break;
        case DOMAIN_WATER:       sDomain = "agua";       break;

            case DOMAIN_METAL:       sDomain = "metal";       break;
            case DOMAIN_STORM:       sDomain = "tormenta";       break;
            case DOMAIN_PORTAL:      sDomain = "portal";       break;
            case DOMAIN_DWARF:       sDomain = "enano";       break;
            case DOMAIN_ORC:         sDomain = "orco";       break;
            case DOMAIN_FORCE:       sDomain = "energia";       break;
            case DOMAIN_SLIME:       sDomain = "cieno";       break;
            case DOMAIN_TIME:        sDomain = "tiempo";       break;
            case DOMAIN_CHARM:       sDomain = "hechizo";       break;
            case DOMAIN_SPELLS:      sDomain = "conjuros";       break;
            case DOMAIN_RUNE:        sDomain = "runa";       break;
            case DOMAIN_FATE:        sDomain = "destino";       break;
            case DOMAIN_DOMINATION:  sDomain = "dominacion";       break;
            case DOMAIN_UNDEATH:     sDomain = "no-muerte";       break;
            case DOMAIN_FAMILY:      sDomain = "familia";       break;
            case DOMAIN_HALFLING:    sDomain = "mediano";       break;
            case DOMAIN_ILLUSION:    sDomain = "ilusion";       break;
            case DOMAIN_HATRED:      sDomain = "odio";       break;
            case DOMAIN_NOBILITY:    sDomain = "nobleza";       break;
            case DOMAIN_RETRIBUTION: sDomain = "retribucion";       break;
            case DOMAIN_SCALEYKIND:  sDomain = "reptiles";       break;
            case DOMAIN_GNOME:       sDomain = "gnomo";       break;
            case DOMAIN_ELF:         sDomain = "elfico";       break;
            case DOMAIN_RENEWAL:     sDomain = "renovacion";       break;
            case DOMAIN_SPYDER:      sDomain = "arania";       break;
            case DOMAIN_TYRANNY:     sDomain = "tirania";       break;
            case DOMAIN_OCEAN:       sDomain = "oceano";       break;
            case DOMAIN_DARKNESS:    sDomain = "oscuridad";       break;

        default: sDomain = "desconocido";
    }
    // Done.
    return sDomain;
}


///////////////////////////////////////////////////////////////////////////////
// RaceToString()
//
// Converts a race code to a plural string description.
//
// Invalid input results in "unknown".
string RaceToString(int nRace)
{
    string sRace = "";  // The returned string. For readability.

    switch ( nRace )
    {
        case RACIAL_TYPE_ABERRATION:         sRace = "aberraciones";         break;
        case RACIAL_TYPE_ANIMAL:             sRace = "animales";             break;
        case RACIAL_TYPE_BEAST:              sRace = "bestias";              break;
        case RACIAL_TYPE_CONSTRUCT:          sRace = "constructos";          break;
        case RACIAL_TYPE_DRAGON:             sRace = "dragones";             break;
        case RACIAL_TYPE_DWARF:              sRace = "enanos";             break;
        case RACIAL_TYPE_ELEMENTAL:          sRace = "elementales";          break;
        case RACIAL_TYPE_ELF:                sRace = "elfos";               break;
        case RACIAL_TYPE_FEY:                sRace = "hadas";                 break;
        case RACIAL_TYPE_GIANT:              sRace = "gigantes";              break;
        case RACIAL_TYPE_GNOME:              sRace = "gnomos";              break;
        case RACIAL_TYPE_HALFELF:            sRace = "semielfos";          break;
        case RACIAL_TYPE_HALFLING:           sRace = "medianos";           break;
        case RACIAL_TYPE_HALFORC:            sRace = "semiorcos";           break;
        case RACIAL_TYPE_HUMAN:              sRace = "humanos";              break;
        case RACIAL_TYPE_HUMANOID_GOBLINOID: sRace = "goblins";          break;
        case RACIAL_TYPE_HUMANOID_MONSTROUS: sRace = "humanoides monstruosos"; break;
        case RACIAL_TYPE_HUMANOID_ORC:       sRace = "orcos";                break;
        case RACIAL_TYPE_HUMANOID_REPTILIAN: sRace = "humanoides reptiles"; break;
        case RACIAL_TYPE_MAGICAL_BEAST:      sRace = "bestias magicas";      break;
        case RACIAL_TYPE_OOZE:               sRace = "oozes";               break;
        case RACIAL_TYPE_OUTSIDER:           sRace = "ajenos";           break;
        case RACIAL_TYPE_SHAPECHANGER:       sRace = "cambiaformas";       break;
        case RACIAL_TYPE_UNDEAD:             sRace = "no muertos";              break;
        case RACIAL_TYPE_VERMIN:             sRace = "insectos";              break;
        default: sRace = "unknown";
    }

    // Done.
    return sRace;
}


///////////////////////////////////////////////////////////////////////////////
// ListToStringAlign()
//
// Converts an list of alignment codes to text, as in "lawful-good or true neutral".
string ListToStringAlign(string sList)
{
    string sText = "";      // The text to be returned.
    string sCurrent = "";   // Holds the text for a single entry as we go through the list.

    // Check for no list entries.
    if ( sList == "" )
        // No list means no text.
        return "de cualquier alineamiento";

    // Convert the first list entry.
    sText = AlignmentToString( StringToInt(GetStringLeft(sList, 10)),
                               StringToInt(GetSubString(sList, 10, 10)) );

    // Advance to the next list entry.
    sList = GetStringRight(sList, GetStringLength(sList) - 20);

    // Check for no second list entry.
    if ( sList == "" )
        // Return what we have.
        return sText;

    // Convert the second list entry.
    sCurrent = AlignmentToString( StringToInt(GetStringLeft(sList, 10)),
                                  StringToInt(GetSubString(sList, 10, 10)) );

    // Advance to the next list entry.
    sList = GetStringRight(sList, GetStringLength(sList) - 20);

    // Check for more list entries.
    if ( sList != "" )
        // This list needs commas.
        sText += ",";

    // Loop through remaining list entries.
    while ( sList != "" )
    {
        // Append the most recent entry to sText.
        sText += " " + sCurrent + ",";

        // Convert the next list entry.
        sCurrent = AlignmentToString( StringToInt(GetStringLeft(sList, 10)),
                                      StringToInt(GetSubString(sList, 10, 10)) );

        // Advance to the next list entry.
        sList = GetStringRight(sList, GetStringLength(sList) - 20);
    }

    // Add the conjunction and return.
    return sText + " o " + sCurrent;
}


///////////////////////////////////////////////////////////////////////////////
// ListToStringDomain()
//
// Converts an list of domain codes to text, as in "animal and plant".
string ListToStringDomain(string sList)
{
    string sText = "";      // The text to be returned.
    string sCurrent = "";   // Holds the text for a single entry as we go through the list.

    // Check for no list entries.
    if ( sList == "" )
        // No list means no text.
        return "";

    // Convert the first list entry.
    sText = DomainToString( StringToInt(GetStringLeft(sList, 10)) );

    // Advance to the next list entry.
    sList = GetStringRight(sList, GetStringLength(sList) - 10);

    // Check for no second list entry.
    if ( sList == "" )
        // Return what we have.
        return sText;

    // Convert the second list entry.
    sCurrent = DomainToString( StringToInt(GetStringLeft(sList, 10)) );
    // Check for a doubled domain. (Often done when a deity only has one NWN domain.)
    if ( sCurrent == sText )
        sCurrent = "un dominio de su alineamiento";

    // Advance to the next list entry.
    sList = GetStringRight(sList, GetStringLength(sList) - 10);

    // Check for more list entries.
    if ( sList != "" )
        // This list needs commas.
        sText += ",";

    // Loop through remaining list entries.
    while ( sList != "" )
    {
        // Append the most recent entry to sText.
        sText += " " + sCurrent + ",";

        // Convert the next list entry.
        sCurrent = DomainToString( StringToInt(GetStringLeft(sList, 10)) );

        // Advance to the next list entry.
        sList = GetStringRight(sList, GetStringLength(sList) - 10);
    }

    // Add the conjunction and return.
    return sText + " y " + sCurrent;
}

///////////////////////////////////////////////////////////////////////////////
// ListToStringRace()
//
// Converts an list of race codes to text, as in "dwarves or elves".
string ListToStringRace(string sList)
{
    string sText = "";      // The text to be returned.
    string sCurrent = "";   // Holds the text for a single entry as we go through the list.

    // Check for no list entries.
    if ( sList == "" )
        // No list means no text.
        return "";

    // Convert the first list entry.
    sText = RaceToString( StringToInt(GetStringLeft(sList, 10)) );

    // Advance to the next list entry.
    sList = GetStringRight(sList, GetStringLength(sList) - 10);

    // Check for no second list entry.
    if ( sList == "" )
        // Return what we have.
        return sText;

    // Convert the second list entry.
    sCurrent = RaceToString( StringToInt(GetStringLeft(sList, 10)) );

    // Advance to the next list entry.
    sList = GetStringRight(sList, GetStringLength(sList) - 10);

    // Check for more list entries.
    if ( sList != "" )
        // This list needs commas.
        sText += ",";

    // Loop through remaining list entries.
    while ( sList != "" )
    {
        // Append the most recent entry to sText.
        sText += " " + sCurrent + ",";

        // Convert the next list entry.
        sCurrent = RaceToString( StringToInt(GetStringLeft(sList, 10)) );

        // Advance to the next list entry.
        sList = GetStringRight(sList, GetStringLength(sList) - 10);
    }

    // Add the conjunction and return.
    return sText + " o " + sCurrent;
}

