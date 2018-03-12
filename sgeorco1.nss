/************** Script Generador de Encuentros - Grupales simples *******************
template author: Inquisidor
script name: OrcoSpawn
script author: Inquisidor
names of the areas this script is asociated with: camino del este de benzor hacia el troll ebrio
********************************************************************************/
#include "RS_FGE_inc"

void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE( GetIsNight() ? 1.1 : 1.0 );

    FGE_Humanoid_Orco( datosSGE );

}

