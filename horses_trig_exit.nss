#include "Horses_StableInc"

void main()
{
    object exitingObject = GetExitingObject();

    //SendMessageToPC(GetFirstPC(), "Trigger: se fue "+GetName(exitingObject));

    Horses_Stable_Trigger_onExit( exitingObject );
}
