/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenoutercv
script author: Inquisidor y Lobofiel
names of the areas this script is asociated with:
Benzor Outer Cave (3)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    datosSGE.faccionId = STANDARD_FACTION_HOSTILE;

    RS_generarMezclado( datosSGE,
        ADE_Insects_Beetle_getVariado()
        + ADE_Insect_Spider_getVariado()
    );
}

