/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgeKobold1
script author: Inquisidor
names of the areas this script is asociated with: Colinas del sur de Benzor (oeste y centro)
********************************************************************************/
#include "RS_FGE_inc"


void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    FGE_Humanoid_Kobold( datosSGE );

}


