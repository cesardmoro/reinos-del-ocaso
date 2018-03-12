/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgegreywood2
script author: Inquisidor
names of the areas this script is asociated with:
Bosques de Bria, Bosque Gris 2
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
        }
        else {
            FGE_Humanoid_WElfTribe( datosSGE );
        }
}
