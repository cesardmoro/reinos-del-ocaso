/************** RandomWay - door onUnlock handler  ****************
Package: RandomWay - door onUnlock event handler
Author: Inquisidor
*******************************************************************************/
#include "RW_implement_inc"
#include "SPC_cofre_inc"

void main() {
    SPC_Placeable_onUnlock( OBJECT_SELF, GetLastUnlocked() );

    if( GetObjectType( GetLastUnlocked() ) == OBJECT_TYPE_CREATURE ) {
        object otherSideBody = RW_Door_getOtherSide(OBJECT_SELF);
        if( GetIsObjectValid( otherSideBody ) && GetLocked(otherSideBody) )
            SetLocked( otherSideBody, FALSE );
    }
}
