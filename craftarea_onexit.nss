#include "IPS_inc"
#include "RS_onExit"

void main() {
    object objetoSaliente = GetExitingObject();

    RS_onExit( objetoSaliente );

    if (GetIsPC(objetoSaliente) && !GetIsDM(objetoSaliente)) {
        object objetoIterado = GetFirstItemInInventory(objetoSaliente);
        while (GetIsObjectValid(objetoIterado)) {
            if (IPS_Item_getIsAdept(objetoIterado))
                IPS_Item_enableProperties(objetoIterado, objetoSaliente);
            objetoIterado = GetNextItemInInventory(objetoSaliente);
        }
    }
}
