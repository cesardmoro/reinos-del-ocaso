// Checks for a PC not qualified to be a cleric of the current deity.

#include "deity_include"

int StartingConditional()
{
    int nDeity = GetLocalInt(OBJECT_SELF, "DeityToTalkAbout");    // Current deity.
    object oPC = GetPCSpeaker();    // The PC.

    // Check alignment and race.
    int bClericOK = CheckClericAlignment(oPC, nDeity) &&
                    CheckClericRace(oPC, nDeity);

    // For current clerics (of other pantheons), check domains.
    if ( bClericOK  &&  GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0 )
        bClericOK = CheckClericDomains(oPC, nDeity);

    if ( bClericOK )
        // Special gender check for Lolth.
        if ( "Lolth" == GetDeityName(nDeity) )
             bClericOK = ( GetGender(oPC) == GENDER_FEMALE );

    // Return TRUE if oPC does *not* qualify as a cleric of nDeity.
    return !bClericOK;
}
