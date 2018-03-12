/*** Replicador de Apariencia - validador de item - ¿es armadura de cuero? *****
Author: Inquisidor
Descripcion: Usado en la conversacion de los mercaderes que replican la apariencia
de armaduras sastre para actualizar el precio de la replicación, y determinar si
lo que lleva puesto el cliente es una armadura de cuero o no.
********************************************************************************/
#include "inc_item_props"
#include "RA_inc"

// devuelve TRUE si la armadura equipada por el cliente es de cuero (1 <= baseAC <= 3).
int StartingConditional() {
    object armaduraEquipada = GetItemInSlot( INVENTORY_SLOT_CHEST, GetPCSpeaker() );
    if( GetIsObjectValid( armaduraEquipada ) ) {
        int baseAC = GetBaseAC( armaduraEquipada );
        if( 1 <= baseAC && baseAC <= 3 ) {
            RA_actualizarPrecioReplicacion( armaduraEquipada );
            return TRUE;
        }
    }
    return FALSE;
}
