/************** Script Generador de Encuentros - Grupales simples *******************
template author: Inquisidor
script name:  sgeOrcishLair
script author:  Lobofiel
names of the areas this script is asociated with:
Enclaves Orcos (exclusivos)
********************************************************************************/
#include "RS_sgeTools"
#include "RS_fge_inc"


void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    FGE_Humanoid_Orco( datosSGE );

}

