#include "Horses_persist"
#include "Horses_StableInc"

const int SCRIPT_NUMBER = 8;

void main()
{
    object oPC = GetPCSpeaker();

    Horses_Stable_retrieveHorse(oPC, SCRIPT_NUMBER);
}
