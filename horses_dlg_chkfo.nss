#include "horses_inc"

int StartingConditional()
{
    return ( (GetPCSpeaker()==Horses_GetHorseOwner(OBJECT_SELF) ||
             (!GetIsPersistantHorse(OBJECT_SELF) && FindSubString(GetResRef(OBJECT_SELF), Horses_PALMOUNT_RESREF_PREFIX) > -1)) &&
            Horses_GetIsHorseFollowing( OBJECT_SELF ) );
}
