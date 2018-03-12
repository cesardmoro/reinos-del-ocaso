#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    object oPC = GetPCSpeaker();
    object oItem = CIGetCurrentModItem(oPC);

    DisplayColors(oPC, oItem);
}
