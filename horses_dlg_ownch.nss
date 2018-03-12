#include "Horses_props_inc"

int StartingConditional()
{
    return (GetPCSpeaker()==Horses_GetHorseOwner(OBJECT_SELF));
}
