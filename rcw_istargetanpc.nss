/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "RCW_inc"

int StartingConditional() {
    object user = GetPCSpeaker();
    object targetObject = GetLocalObject( user, RCW_targetObject_VN );
    return GetLocalInt( user, RCW_wandState_VN ) == 0 && GetObjectType( targetObject ) == OBJECT_TYPE_CREATURE && !GetIsPC( targetObject );
}
