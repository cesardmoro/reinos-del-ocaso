/************** RandomWay - door onClose handler  ****************
Package: RandomWay - door onClose event handler
Author: Inquisidor
*******************************************************************************/
#include "RW_implement_inc"

void main() {
//    SendMessageToPC( GetFirstPC(), "RW_door_onClose excecuted" );
    if( GetObjectType( GetLastClosedBy() ) == OBJECT_TYPE_CREATURE ) {
        object otherSideBody = RW_Door_getOtherSide(OBJECT_SELF);
        if( GetIsObjectValid( otherSideBody ) && GetIsOpen(otherSideBody) )
            ActionCloseDoor( otherSideBody );
    }
}
