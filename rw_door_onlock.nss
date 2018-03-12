/************** RandomWay - door onLock handler  ****************
Package: RandomWay - door onLock event handler
Author: Inquisidor
*******************************************************************************/
#include "RW_implement_inc"

void main() {
    if( GetObjectType( GetLastLocked() ) == OBJECT_TYPE_CREATURE ) {
        object otherSideBody = RW_Door_getOtherSide(OBJECT_SELF);
        if( GetIsObjectValid( otherSideBody ) && !GetLocked(otherSideBody) )
            SetLockLockable( otherSideBody, TRUE );
            SetLockKeyRequired( otherSideBody, GetLockKeyRequired(OBJECT_SELF) );
            SetLockKeyTag( otherSideBody, GetLockKeyTag(OBJECT_SELF) );
            SetLocked( otherSideBody, TRUE );
//            SendMessageToPC( GetFirstPC(), "RW_Door_onLock: locked" );
    }
}
