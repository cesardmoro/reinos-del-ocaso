/****** Replicador de Apariencia - validador de item - ¿es atuendo? *********
Author: Inquisidor
Descripcion: Usado en la conversacion de los mercaderes que replican la apariencia
de armaduras para actualizar el precio de la replicación, y determinar si lo que
lleva puesto el cliente es un atuendo o no lo es.
********************************************************************************/
#include "inc_item_props"
#include "RA_inc"

// actualiza el custom token 5800 con el precio de la replicación,
// y devuelve TRUE si la armadura equipada por el cliente es un atuendo
int StartingConditional() {
    object armaduraEquipada = GetItemInSlot( INVENTORY_SLOT_CHEST, GetPCSpeaker() );
//    SendMessageToPC( GetFirstPC(), "valido="+IntToString(GetIsObjectValid( armaduraEquipada ))+", baseAC="+IntToString(GetBaseAC( armaduraEquipada )) );
    if( GetIsObjectValid( armaduraEquipada ) && GetBaseAC( armaduraEquipada ) == 0 ) {
        RA_actualizarPrecioReplicacion( armaduraEquipada );
        return TRUE;
    }
    return FALSE;
}
