/************************ Cofre_onTrapDisarmed event handler *******************
Paquete: SPC - Cofre
Author: Inquisidor
Este script es atado al placeable automaticamente cuando a este placeable se le monta una trampa usando 'SPC_Placeable_montarObstaculo(..)'.
*******************************************************************************/
#include "SPC_cofre_inc"

void main() {
    SPC_Placeable_onTrapDisarmed(OBJECT_SELF);
}
