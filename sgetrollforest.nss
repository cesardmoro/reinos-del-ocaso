/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgetrollforest
script author: Lobofiel
names of the areas this script is asociated with:
Bosque del Troll
********************************************************************************/
#include "RS_FGE_inc"
void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // Opciones
    // 1) Ambiente Pantano
    // 2) Ambiente Bosque Calido
    if (Random (2) == 0){
        RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
    }
    else {
        RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
    }
}
