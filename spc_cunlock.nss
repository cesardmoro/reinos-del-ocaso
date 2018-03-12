/********************** SPC_Cofre_onTrapUnlocked event handler *****************
Paquete: SPC - Cofre
Author: Inquisidor
Script manejador del evento onUlock que debe estar atado a todos los placeables a los que se le monte una traba usando 'SPC_Placeable_montarObstaculo(..)'.
Ejemplos de placeables que tienen este script atado son los cofres en Placeables/Custom/Treasure. Tales cofres son instanciados por 'SPC_Cofre_determinarDestinoTesoro(..)'.
*******************************************************************************/

#include "SPC_cofre_inc"

void main() {
    SPC_Placeable_onUnlock( OBJECT_SELF, GetLastUnlocked() );
}
