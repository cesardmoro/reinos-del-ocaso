/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgedungeonwild
script author: Inquisidor
names of the areas this script is asociated with:

********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    int selector = Random(7);
    if( selector == 0 ) {
        RS_generarGrupo( datosSGE, ADE_Humanoid_Lizardmen_getMelee() );
    } else if( selector == 1 ) {
        RS_generarGrupo( datosSGE, ADE_Insects_Ants_get() );
    } else if( selector == 2 ) {
        RS_generarGrupo( datosSGE, ADE_Planar_Formicida_getMelee() );
    } else {
        RS_generarMezclado( datosSGE, FGE_DungeonWild_getVariado() );
    }
}
