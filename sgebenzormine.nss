/****************** Script Generador de Encuentros -
COMPUESTO****************
template author: Inquisidor
script name: sgebenzormine
script author: Lobofiel
names of the areas this script is asociated with:
Minas de Benzor
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    datosSGE.faccionId = STANDARD_FACTION_HOSTILE;

    if( d2()==1 )
        FGE_Humanoid_TrasgoCaverna( datosSGE );
    else
        RS_generarMezclado( datosSGE,
            ADE_Insect_Spider_getVariado()
            + ADE_Insects_Beetle_getVariado()
            + ADE_Aberrations_Underground_getVariado()
        );
}


