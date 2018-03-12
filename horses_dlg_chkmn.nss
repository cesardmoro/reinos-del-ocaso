#include "horses_props_inc"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return (GetIsMounted(oPC) && Horses_GetHorseOwner(Horses_GetMountedHorse(oPC))==oPC);
}
