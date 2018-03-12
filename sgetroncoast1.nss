/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeTronCoast1
script author: Inquisidor
names of the areas this script is asociated with:
Trondor Coast 1
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
        else {
            FGE_Humanoid_Orco( datosSGE );
        }
}
