#include "Horses_craft"

void main()
{
    object oPC = GetPCSpeaker();
    int horseId = GetLocalInt(oPC, Horses_CURRENT_HORSE);
    object oHorse = Horses_GetHorseByIdAndOwner(horseId, oPC);

    Horses_Craft_Start(oHorse);
}
