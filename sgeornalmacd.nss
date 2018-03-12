/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalmacD
script author: Lobofiel
names of the areas this script is asociated with:
Macizo Ornal D, (Territorio Orcos del Ojo Ciego)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();  {

    // 1) Orcos
    // 2) Ambiente Quebradas
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_Orco( datosSGE );
        }
    }
}

