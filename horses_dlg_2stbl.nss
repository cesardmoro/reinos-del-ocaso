#include "Horses_inc"

void main()
{
    object oPC = GetPCSpeaker();
    object oHorse = OBJECT_SELF;

    Horses_StopFollowing( oHorse, oPC );
    Horses_SendHorseToStable( oHorse );
}
