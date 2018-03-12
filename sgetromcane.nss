/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgetromcanE
script author: Lobofiel
names of the areas this script is asociated with:
Paso de Trommel, Canones Occ.
********************************************************************************/
#include "RS_FGE_inc"
void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // Opciones
    // 1) Human Barbarian
    // 2) Ambiente Quebradas
    if (Random (2) == 0){
        RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
    }
    else {
        FGE_Humanoid_HuBarbarian( datosSGE );
    }
}
