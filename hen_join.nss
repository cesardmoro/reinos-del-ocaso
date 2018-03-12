//:://////////////////////////////////////////////////
//:: X0_D1_HEN_REJOIN
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
Actions taken when a henchman rejoins his/her current
master.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 09/13/2002
//:://////////////////////////////////////////////////
#include "x0_i0_henchman"

void DoHireHenchman(object oPC, object oHench=OBJECT_SELF, int bAdd=TRUE);

void main()
{
    DoHireHenchman(GetPCSpeaker());
}

void DoHireHenchman(object oPC, object oHench=OBJECT_SELF, int bAdd=TRUE)
{
    if ( !GetIsObjectValid(oPC) || !GetIsObjectValid(oHench) )
    {
        return;
    }

   // Mark the henchman as working for the given player
    if (!GetPlayerHasHired(oPC, oHench))
    {
        SetPlayerHasHired(oPC, oHench);
    }
    SetLastMaster(oPC, oHench);

    // Clear the 'quit' setting in case we just persuaded
    // the henchman to rejoin us.
    SetDidQuit(oPC, oHench, FALSE);

    // If we're hooking back up with the henchman after s/he
    //  died, clear that.
    SetDidDie(FALSE, oHench);
    SetKilled(oPC, oHench, FALSE);
    SetResurrected(oPC, oHench, FALSE);

    // Turn on standard henchman listening patterns
    SetAssociateListenPatterns(oHench);


    // Add the henchman
    if (bAdd == TRUE)
    {
        AddHenchman(oPC, oHench);
    }

}
