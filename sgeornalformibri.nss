/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalformibri
script author: Lobofiel
names of the areas this script is asociated with:
Costa de Bria 1 , Territorio Formicida
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    if (Random (2) == 0){
    RS_generarMezclado( datosSGE, FGE_Pradera_getVariado());
    }
    else {
        FGE_Planar_Formicida( datosSGE );
    }
}


