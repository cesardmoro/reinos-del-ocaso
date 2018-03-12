#include "Horses_persist"

int StartingConditional()
{
    return (GetMaster(OBJECT_SELF) == GetPCSpeaker());
}
