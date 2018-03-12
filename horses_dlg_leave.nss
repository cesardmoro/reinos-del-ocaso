#include "horses_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oHorse = Horses_GetMountedHorse(oPC);

    Horses_disMount(oPC, FALSE);
    SetCampaignString(Horses_DATABASE, Horses_DB_HORSE_STABLE_PREFIX+IntToString(Horses_GetHorseId(oHorse)), GetTag(GetArea(oPC)), oPC);
}
