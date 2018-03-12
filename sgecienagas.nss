/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgeCienagas
script author: Inquisidor
names of the areas this script is asociated with: Cienagas
********************************************************************************/
#include "RS_FGE_inc"


void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    FGE_Humanoid_Saurion( datosSGE );
}

