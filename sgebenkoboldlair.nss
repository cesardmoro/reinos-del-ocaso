/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgebenkoboldlair
script author: Inquisidor y Lobofiel
names of the areas this script is asociated with:
Benzor - Enclave Kobold (x2)
********************************************************************************/
#include "RS_FGE_inc"


void main()  {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    FGE_Humanoid_Kobold( datosSGE );
}







