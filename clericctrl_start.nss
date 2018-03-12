#include "ClericCtrl_inc"

int StartingConditional()
{
    SetCustomToken(4001, GetName(GetLocalObject(OBJECT_SELF, ClericControl_wandTargetObject_LN)));
    return TRUE;
}
