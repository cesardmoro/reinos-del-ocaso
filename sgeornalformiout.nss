/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalformiout
script author: Lobofiel
names of the areas this script is asociated with:
Macizo Ornal , Territorio Formicida
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    if (Random (2) == 0){
        RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
    }
    else {
        FGE_Planar_Formicida( datosSGE );
    }
}


