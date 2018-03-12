/****** Replicador de Apariencia - registra item original *********
Author: Inquisidor
Descripcion: Usado en la conversacion del mercader para registrar el item original.
El item registrado es el que tenga el cliente equipado en el slot indicado por
la propiedad RA_idInventorySlot_PN
********************************************************************************/
#include "RA_inc"

void main() {
    object itemOriginal = GetItemInSlot( GetLocalInt( OBJECT_SELF, RA_idInventorySlot_PN ), GetPCSpeaker() );
    SetLocalObject( OBJECT_SELF, RA_itemOriginal_VN, itemOriginal );
}
