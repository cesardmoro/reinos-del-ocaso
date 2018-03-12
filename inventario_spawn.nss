#include "inventario_inc"

void main()
{
    object oModulo = GetModule();
    SetLocalObject(oModulo, Inventario_EFFECT_CREATOR, OBJECT_SELF);
}
