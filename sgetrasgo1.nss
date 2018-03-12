/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgeTrasgo1
script author: Inquisidor
names of the areas this script is asociated with: Ninguna, existe solo para usar con la RS_DMC wand
********************************************************************************/
#include "RS_FGE_inc"


void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    FGE_Humanoid_Trasgo( datosSGE );
}


