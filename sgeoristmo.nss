/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeoristmo
script author: Lobofiel
names of the areas this script is asociated with:
Ornal Istmo (1)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    if (GetIsDay()) {
        RS_generarMezclado( datosSGE,
            ADE_Animales_AveDiurna_getVariado()
            + ADE_Animales_Campo_getVariado()
        );
    }
    else {
        RS_generarMezclado( datosSGE,
            ADE_Animales_Campo_getVariado()
            + ADE_Animales_Alimanias_getVariado()
            + ADE_Animales_Lobos_getVariado()
        );
    }
}

