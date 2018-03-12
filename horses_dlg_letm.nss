#include "Horses_props_inc"

int StartingConditional()
{
    return (GetPCSpeaker()==Horses_GetHorseOwner(OBJECT_SELF) && GetLocalInt(OBJECT_SELF, Horses_OWNER_ALLOWS_OTHERS_TO_RIDE) > 0);
}
