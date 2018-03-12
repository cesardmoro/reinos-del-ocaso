/*** Replicador de Apariencia - validador de item - ¿es metálica la armadura equipada? *****
Author: Inquisidor
Descripcion: Usado en la conversacion de los mercaderes que replican la apariencia
de armaduras para actualizar el precio de la replicación, y determinar si lo que
lleva puesto el cliente es una armadura metálica o no.
********************************************************************************/
#include "inc_item_props"
#include "RA_inc"

// devuelve TRUE si la armadura equipada por el cliente es metalica (AC >= 4).
int StartingConditional() {
    object armaduraEquipada = GetItemInSlot( INVENTORY_SLOT_CHEST, GetPCSpeaker() );
    if( GetIsObjectValid( armaduraEquipada ) ) {
        if( GetBaseAC( armaduraEquipada ) >=4 ) {
            RA_actualizarPrecioReplicacion( armaduraEquipada );
            return TRUE;
        }
    }
    return FALSE;
}
