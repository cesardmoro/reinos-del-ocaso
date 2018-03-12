/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "FUW_inc"
#include "RCW_inc"

void main() {
    object targetObject = GetLocalObject( GetPCSpeaker(), RCW_targetObject_VN );
    object targetArea =
        GetIsObjectValid( targetObject )
        ? GetArea( targetObject )
        : GetAreaFromLocation( GetLocalLocation( GetPCSpeaker(), RCW_targetLocation_VN ) )
    ;
    FUW_unfreezeAllNpcsInArea( targetArea );
}
