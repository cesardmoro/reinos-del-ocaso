#include "Horses_inc"

void main()
{
    object exitingObject = GetExitingObject();

    if (GetIsRidableHorse(exitingObject)) {
        SetPlotFlag(exitingObject, FALSE);

        if (Horses_GetIsHorseFollowing( exitingObject ))
            // Si esta siguiendo, continuar la dominacion
            Horses_StartFollowing( exitingObject, Horses_GetHorseOwner(exitingObject) );
    }
}
