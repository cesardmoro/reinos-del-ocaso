/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: EsterosSpawn
script author: Inquisidor
names of the areas this script is asociated with: esteros centrales
********************************************************************************/
#include "RS_FGE_inc"


void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    if( Random(5) == 0 )
        RS_generarGrupo( datosSGE, FGE_NPC_mercenary_get() );
    else
        RS_generarMezclado( datosSGE, ADE_EsterosCentrales_Camino_getVariado() );
}

