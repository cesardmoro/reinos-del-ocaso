#include "Horses_craft"
#include "Horses_StableInc"

void main()
{
    object oPC = GetPCSpeaker();
    int horseId = GetLocalInt(oPC, Horses_CURRENT_HORSE);
    object oHorse = Horses_GetHorseByIdAndOwner(horseId, oPC);

    Horses_Craft_End(oHorse, horseId, oPC);

    DeleteLocalInt(oPC, Stable_HAS_TO_CRAFT);
    SetLocalInt(oPC, Stable_HAS_TO_NAME, TRUE);
}
