/*************** RandomWay - area onExit event handler  ***********************
Package: RandomWay - area onExit event handler
Author: Inquisidor
*******************************************************************************/
#include "RW_facade_inc"

void main() {
//    SendMessageToPC( GetFirstPC(), "RW_Area_onExit: begin" );
    object exitingObject = GetExitingObject();
    if( !GetIsPC( exitingObject ) || !GetLocalInt( exitingObject, RW_PC_hasToIgnoreAreaOnExitEvent_VN ) )
        ExecuteScript( RW_COMMON_AREA_ON_EXIT_SCRIPT, OBJECT_SELF );

//    SendMessageToPC( GetFirstPC(), "RW_Area_onExit: end" );
}
