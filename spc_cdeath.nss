/************************ Cofre_onDeath event handler *******************
Paquete: SPC - Cofre
Author: Inquisidor
Handler del evento onDeath de los cofres en Placeables/Custom/Treasure
Tales cofres son instanciados por 'SPC_Cofre_determinarDestinoTesoro(..)'.
*******************************************************************************/
#include "SPC_cofre_inc"

void main() {
//    SendMessageToPC( GetFirstPC(), "SPC_cDeath: begin");
    SPC_Cofre_onDeath(OBJECT_SELF);
//    SendMessageToPC( GetFirstPC(), "SPC_cDeath: end");
}
