/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenzorcanyon1
script author: Lobofiel
names of the areas this script is asociated with:
Canyon del Rio Benzor 1
********************************************************************************/
#include "RS_FGE_inc"
void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // Opciones
    // 1) Orcos
    // 2) Ambiente Quebradas
    if (Random (2) == 0){
        RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
    }
    else {
        FGE_Humanoid_Orco( datosSGE );
    }
}
