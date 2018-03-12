// this script runs when the player selects the form 4 from the list to shift into

#include "nw_i0_generic"
#include "inc_soul_shift"

void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    // add index to the start
    nStartIndex+=3;
    ShiftFromKnownArray(nStartIndex,TRUE,oPC);
}
