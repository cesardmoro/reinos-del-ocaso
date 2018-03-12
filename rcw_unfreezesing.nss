/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "FUW_inc"
#include "RCW_inc"

void main() {
    object user = GetPCSpeaker();
    object targetObject = GetLocalObject( user, RCW_targetObject_VN );
    if( GetObjectType( targetObject ) == OBJECT_TYPE_CREATURE )
        FUW_unfreezeCreature( targetObject );
    else
        SendMessageToPC( user, "Invalid target!" );

}
