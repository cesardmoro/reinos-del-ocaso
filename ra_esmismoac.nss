/*** Replicador de Apariencia - validador de item - ¿es armadura equipada del mismo AC que la original? *****
Author: Inquisidor
Descripcion: Usado en la conversacion de los mercaderes que replican la apariencia
de armaduras para actualizar el precio de la replicación, y determinar si lo que
lleva puesto el cliente (la armadura a modificar) es del mismo AC que la original.
********************************************************************************/
#include "inc_item_props"
#include "RA_inc"

// devuelve TRUE si la armadura equipada por el cliente es metalica (AC >= 4).
int StartingConditional() {
    object armaduraEquipada = GetItemInSlot( INVENTORY_SLOT_CHEST, GetPCSpeaker() );
    if( GetIsObjectValid( armaduraEquipada ) ) {
        if( GetBaseAC( armaduraEquipada ) == GetBaseAC( GetLocalObject( OBJECT_SELF, RA_itemOriginal_VN ) ) ) {
            RA_actualizarPrecioReplicacion( armaduraEquipada );
            return TRUE;
        }
    }
    return FALSE;
}
