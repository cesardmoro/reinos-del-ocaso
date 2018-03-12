/****** Replicador de Apariencia - validador de item - �es atuendo? *********
Author: Inquisidor
Descripcion: Usado en la conversacion de los mercaderes que replican la apariencia
de armaduras para verificar que la propiedad del mercader haya sido correctamente seteada.
********************************************************************************/
#include "RA_inc"

int StartingConditional() {
    return GetLocalInt( OBJECT_SELF, RA_idInventorySlot_PN ) != INVENTORY_SLOT_CHEST;
}
