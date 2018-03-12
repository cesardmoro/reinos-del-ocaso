/****************** Script Generador de Encuentros - Solitarios ****************
template author: Inquisidor
script name: sgebenhechi
script author:  Inquisidor
names of the areas this script is asociated with:
Ruinas de la Torre de Hechiceria de Benzor
********************************************************************************/

#include "RS_FGE_inc"

void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    datosSGE.faccionId = STANDARD_FACTION_HOSTILE; // esta por temor a que haya elementos de facciones enemigas

    string arregloDVD = FGE_Elemental_Mixed1_getVariado();

    if( datosSGE.dificultadEncuentro < 6 )
        arregloDVD += ADE_Animated_Mixed1_getVariado();
    else
        arregloDVD += FGE_Golem_Mixed1_getVariado();

    RS_generarMezclado( datosSGE, arregloDVD );
}
