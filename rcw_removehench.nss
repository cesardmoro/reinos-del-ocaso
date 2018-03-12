/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "RCW_inc"

void main() {
    object targetObject = GetLocalObject( GetPCSpeaker(), RCW_targetObject_VN );
    object master = GetMaster( targetObject );
    if( GetIsObjectValid( master ) ) {
        RemoveHenchman( master, targetObject );
        SendMessageToPC( GetPCSpeaker(), "Success! Now the target is no more a henchman of "+GetName(master) );
        AssignCommand( targetObject, ClearAllActions() );
    }
    else
        SendMessageToPC( GetPCSpeaker(), "The target has no master. Operation canceled." );
}
