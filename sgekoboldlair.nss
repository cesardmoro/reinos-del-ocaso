/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgekoboldlair
script author: Inquisidor y Lobofiel
names of the areas this script is asociated with:
Encalves Kobold Exclusivamente
********************************************************************************/
#include "RS_FGE_inc"


void main()  {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    FGE_Humanoid_Kobold( datosSGE );
}







