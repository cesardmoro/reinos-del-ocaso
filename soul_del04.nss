//for the form selected from the list and confermed, delete from known forms array

#include "nw_i0_generic"
#include "inc_soul_shift"

void main()
{
    object oPC = GetPCSpeaker();
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    // add index to the start
    nStartIndex+=3;
    DeleteFromKnownArray(nStartIndex,oPC);
}
