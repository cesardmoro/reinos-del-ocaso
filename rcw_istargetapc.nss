/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "RCW_inc"

int StartingConditional() {
    object user = GetPCSpeaker();
    return GetLocalInt( user, RCW_wandState_VN ) == 0 && GetIsPC( GetLocalObject( user, RCW_targetObject_VN ) );
}
