// this script runs when the player selects the form 2 from the list to shift into

#include "nw_i0_generic"
#include "pnp_shft_main"

void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    // add index to the start
    nStartIndex+=1;
    ShiftFromKnownArray(nStartIndex,TRUE,oPC);
}
