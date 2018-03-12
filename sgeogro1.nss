/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgeOgro1
script author: Inquisidor
names of the areas this script is asociated with: cavernas del bosque sombrio
********************************************************************************/
#include "RS_FGE_inc"


void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    FGE_Giant_Ogro( datosSGE );
}

