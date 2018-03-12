#include "ClericCtrl_inc"

void main()
{
    object targetCleric = GetLocalObject( OBJECT_SELF, ClericControl_wandTargetObject_LN );
    SetTimeClericCantCastSpellsFor( targetCleric, 2);
}
