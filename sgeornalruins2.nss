/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgecriptas
script author: Lobofiel
names of the areas this script is asociated with:
Macizo Ornal, Ruinas (interior)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    //5% posibilidades de encuentro Bodak
    if (Random (20) == 0){
        RS_generarMezclado( datosSGE,ADE_Undead_Bodak_getVariado());
    }
    else {
        RS_generarGrupo( datosSGE, FGE_Undead_get());
    }
}
