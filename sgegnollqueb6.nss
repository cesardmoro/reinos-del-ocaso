/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgegnollqueb6
script author: Lobofiel
names of the areas this script is asociated with:
Quebradas del Gnoll Ladrador 6
********************************************************************************/
#include "RS_FGE_inc"
void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // Opciones
    // 1) Gnolls
    // 2) Ambiente Quebradas
    if (Random (2) == 0){
        RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
    }
    else {
        FGE_Humanoid_Gnoll( datosSGE );
    }
}
