///////////////////////////////////////////////////////////////////////////////
// deity_onlevel.nss
//
// Created by: The Krit
// Date: 11/06/06
///////////////////////////////////////////////////////////////////////////////
//
// This file is probably not something you want to change (other than the
// WORLDNAME constant). It implements the checks that a PC has not violated
// pantheon rules when leveling.
//
///////////////////////////////////////////////////////////////////////////////
//
// To use, call CheckDeityRestrictions() in your module's OnLevelUp event.
// (The parameter should be the object leveling up, either GetPCLevellingUp()
// or a variable that has been assigned that value.)
//
// A TRUE return value indicates that the PC leveled ok.
//
// A FALSE return value indicates that the PC violated a rule and should be
// dealt with. (A message will have been sent to the PC explaining why the
// levelup was bad, but no actual de-leveling takes place in this file.)
//
// If all levelup checks are passed, call DeityRestrictionsPostLoad() to
// prepare for the next levelup.


#include "deity_include"
#include "experience_inc"

// Set the following string to describe your world.
const string WORLDNAME = "Abeil Toril";

///////////////////////////////////////////////////////////////////////////////
// CheckDeityRestrictions()
//
// Returns FALSE if oPC just gained a cleric level, but does not meet the
// deity's requirements.
//
// Returns TRUE otherwise.
//
// "Just gained" means since character creation or the last call to
// DeityRestrictionsPostLevel(), whichever was most recent.
//
int CheckDeityRestrictions(object oPC)
{
    int bOK = FALSE;    // Flag indicating if the most recent level is accepted.
    int nOldClericLevel = GetLocalInt(oPC, "ClericLevel");          // Old cleric level.
    int nNewClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);  // New cleric level.

    // Check if a cleric level was added.
    if ( nNewClericLevel == nOldClericLevel )
        // No cleric levels added, so all is ok by this function.
        bOK = TRUE;
    else
    {
        int nDeity = GetDeityIndex(oPC);    // Current deity.

        // Check for an invalid deity.
        if ( nDeity < 0 )
            // Tell the player why this is rejected.
            SendMessageToPC(oPC, "El dios que elegiste es invalido. Por favor, elige nuevamente un dios.");

        // Check for an invalid alignment.
        else if ( !CheckClericAlignment(oPC, nDeity) )
        {
            // Tell the player why this is rejected.
            if ( nOldClericLevel == 0 )
                SendMessageToPC(oPC, GetDeity(oPC) + "no acepta a aquellos de tu calibre moral!");
            else
                SendMessageToPC(oPC, "Haz perdido la gracia de " + GetDeity(oPC) + "!");
        }

        // Check for an invalid race.
        else if ( !CheckClericRace(oPC, nDeity) )
            // Tell the player why this is rejected.
            SendMessageToPC(oPC, GetDeity(oPC) + " no acepta a los de tu raza!");

        // Check for an invalid domain.
        else if ( !CheckClericDomains(oPC, nDeity) )
            // Tell the player why this is rejected.
            SendMessageToPC(oPC, "No haz elegido dominios que plazcan a " + GetDeity(oPC) + "!");

        else
            // Passed all checks!
            bOK = TRUE;
    }//else (cleric level added)

    return bOK;
}


///////////////////////////////////////////////////////////////////////////////
// DeityRestrictionsPostLevel()
//
// Call after CheckDeityRestrictions() to record the current level as accepted.
//
void DeityRestrictionsPostLevel(object oPC)
{
    SetLocalInt(oPC, "ClericLevel", GetLevelByClass(CLASS_TYPE_CLERIC, oPC));
}
