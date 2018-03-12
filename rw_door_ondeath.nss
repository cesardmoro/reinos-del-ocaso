/************** RandomWay - door onDeath handler  ****************
Package: RandomWay - door onDeath event handler
Author: Inquisidor
*******************************************************************************/
#include "RW_implement_inc"

void main() {
    object otherSideBody = RW_Door_getOtherSide(OBJECT_SELF);
    if( GetIsObjectValid( otherSideBody ) )
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage(9999), otherSideBody );
}
