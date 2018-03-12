/************ Replicador de Apariencia - realiza la replicacion ***************
Author: Inquisidor
Descripcion: Usado en la conversacion de los mercaderes replicadores de apariencia
para cobrar lo que vale la replicacion.
********************************************************************************/
#include "RA_inc"

void main() {
    RA_cobrarReplicacion( GetPCSpeaker() );
    RA_proceder( GetPCSpeaker() );
}
