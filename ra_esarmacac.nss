/****** Replicador de Apariencia - validador de item - ¿es un arma cuerpo a cuerpo? *********
Author: Inquisidor
Descripcion: Usado en la conversacion de los mercaderes que replican la apariencia
de armas cuerpo a cuerpo para actualizar el precio de la replicación, y determinar si el cliente
lleva una equipada en 'RA_idInventorySlot_PN'.
********************************************************************************/
#include "RA_inc"

// actualiza el custom token 5800 con el precio de la replicación,
// y devuelve TRUE si el cliente tiene algo equipado en RA_idInventorySlot_PN
int StartingConditional() {
    object itemEquipado = GetItemInSlot( GetLocalInt( OBJECT_SELF, RA_idInventorySlot_PN ), GetPCSpeaker() );
    if( Item_GetIsMeleeWeapon( itemEquipado ) ) {
        RA_actualizarPrecioReplicacion( itemEquipado );
        return TRUE;
    }
    return FALSE;
}
