/****************** Script Generador de Encuentros -COMPUESTO****************
template author: Inquisidor
script name: sgeornalformiin
script author: Lobofiel
names of the areas this script is asociated with:
Cavernas del Macizo Ornal , Colonia Formicida (interiores)
********************************************************************************/

#include "RS_FGE_inc"


void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    FGE_Planar_Formicida( datosSGE );
}
