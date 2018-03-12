/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgewelfbarbtribe
script author: Lobofiel
names of the areas this script is asociated with:
Wild Elf Barbarian Tribes exclusivamente
********************************************************************************/
#include "RS_sgeTools"
#include "RS_fge_inc"


void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    FGE_Humanoid_WElfTribe( datosSGE );

}
