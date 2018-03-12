#include "Horses_StableInc"

int StartingConditional()
{
    return (GetLocalInt(GetPCSpeaker(), Stable_HAS_TO_NAME) == TRUE);
}
