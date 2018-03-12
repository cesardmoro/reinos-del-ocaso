#include "Horses_props_inc"

const int SLOT_NUMBER = 7;

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int horseId = GetLocalInt(OBJECT_SELF, Horses_HORSE_IN_SLOT+IntToString(SLOT_NUMBER));
    return (horseId > 0 && horseId != Horses_GetHorseId(Horses_GetMountedHorse(oPC)));
}
