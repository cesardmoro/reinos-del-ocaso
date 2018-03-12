/*** Replicador de Apariencia - validador de fondos - ¿tiene el cliente suficiente dinero? *****
Author: Inquisidor
Descripcion: Usado en la conversacion de los mercaderes replicadores de apariencia
para averiguar si el cliente tiene suficiente dinero para pagar la replicacion.
********************************************************************************/
#include "RA_inc"

int StartingConditional() {
    return GetGold( GetPCSpeaker() ) >= GetLocalInt( OBJECT_SELF, RA_precioReplicacion_VN );
}
