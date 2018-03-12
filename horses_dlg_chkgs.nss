#include "Horses_persist"

int StartingConditional()
{
    return (GetPCSpeaker()==Horses_GetHorseOwner(OBJECT_SELF) && GetIsPersistantHorse(OBJECT_SELF));
}
