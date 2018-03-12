/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "RCW_inc"

void main() {
    object user = GetPCSpeaker();
    object targetObject = GetLocalObject( user, RCW_targetObject_VN );

    if( GetIsObjectValid( targetObject ) )
        RCW_showReputationOfTargetAgainstAllCreaturesInArea( targetObject, GetArea( user ) );
}
