//:://////////////////////////////////////////////////
//:: X0_CH_HEN_DEATH
//:: Copyright (c) 2002 Floodgate Entertainment
//:://////////////////////////////////////////////////
/*
  OnDeath handler for henchmen ONLY. Causes them to respawn at
  (in order of preference) the respawn point of their master
  or their own starting location.
 */
//:://////////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: 10/09/2002
//:://////////////////////////////////////////////////

#include "x0_i0_henchman"

void main()
{
    // Handle a bunch of stuff to keep us from running around,
    // Get our last master
    object oPC = GetLastMaster();
      // Clear dialogue events
    ClearAllDialogue(oPC, OBJECT_SELF);
    ClearAllActions();
}
