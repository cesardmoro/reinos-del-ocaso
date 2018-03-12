/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgeBosqSomb2
script author: Inquisidor
names of the areas this script is asociated with:
bosque sombrio
********************************************************************************/
#include "RS_FGE_inc"


void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    FGE_Undead_Fantasma( datosSGE );
}

