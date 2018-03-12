#include "Horses_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oHorse = OBJECT_SELF;

    Horses_Mount(oHorse, oPC);
}
