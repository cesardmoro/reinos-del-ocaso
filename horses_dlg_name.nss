#include "Horses_persist"
#include "Horses_StableInc"

void main()
{
    object oPC = GetPCSpeaker();
    object oHorse = Horses_GetHorseByIdAndOwner(GetLocalInt(oPC, Horses_CURRENT_HORSE), oPC);
    string horseName = GetLocalString(oPC, Horses_CURRENT_NAME);

    Horses_SetPersistantHorseName(horseName, oHorse, oPC);
    //SendMessageToPC(oPC, "HorseNaming:  horseName="+horseName+"  horseId="+IntToString(GetLocalInt(oPC, Horses_CURRENT_HORSE)));

    DeleteLocalInt(oPC, Horses_CURRENT_HORSE);
    DeleteLocalString(oPC, Horses_CURRENT_NAME);
    DeleteLocalInt(oPC, Stable_HAS_TO_NAME);
}
