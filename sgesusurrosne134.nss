/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgesusurrosNE134
script author: Lobofiel
names of the areas this script is asociated with:
Bosque de los Susurros, NE1, NE3 y NE4
********************************************************************************/
#include "RS_FGE_inc"
void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // Opciones
    // 1) Wild Elf Barbarian
    // 2) Ambiente Bosque Calido
    if (Random (2) == 0){
        RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
    }
    else {
        FGE_Humanoid_WElfTribe( datosSGE );
    }
}
