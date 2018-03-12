/************** RandomWay - door onOpen handler  ****************
Package: RandomWay - door onOpen event handler
Author: Inquisidor
*******************************************************************************/
#include "RW_implement_inc"

void main() {
//    SendMessageToPC( GetFirstPC(), "RW_door_onOpen excecuted" );
    if( GetObjectType( GetLastOpenedBy() ) == OBJECT_TYPE_CREATURE ) {
        object otherSideBody = RW_Door_getOtherSide(OBJECT_SELF);
        if( GetIsObjectValid( otherSideBody ) && !GetIsOpen(otherSideBody) )
            ActionOpenDoor( otherSideBody );
    }
}
