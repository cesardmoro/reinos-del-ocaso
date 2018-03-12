///////////////////////////////////////////////////////////////////////////////
// A module's OnLevel event handler.
//
// A simple function containing just what the deity restrictions require.
//
// For a more complete function into which other functions can be added,
// see on_level1.
//
// Embellish as needed.
///////////////////////////////////////////////////////////////////////////////


#include "deity_onlevel"
#include "experience_inc"


///////////////////////////////////////////////////////////////////////////////
// main()
//
// Checks for violations of world policy, and uses ResetLevel() if one is found.
// Returns whether oPC meets the deity restrictions or not
int deity_eventOnLevelUp( object oPC  = OBJECT_SELF );
int deity_eventOnLevelUp( object oPC  = OBJECT_SELF )
{
    int meetsRestrictions = CheckDeityRestrictions(oPC);
    // See if oPC violated the deity rules.
    if ( !meetsRestrictions ) {
        // Unlevel
        ResetLevel(oPC);
        // Si la deidad no es una deidad de las del modulo...
        if (GetDeityIndex(oPC)<0)
            //... abrir el dialogo
            AssignCommand(oPC, ActionStartConversation(oPC, "deityconv_inicio"));
    } else
        // Prepare for future restrictions.
        DeityRestrictionsPostLevel(oPC);

    return meetsRestrictions;
}

