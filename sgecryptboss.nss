/************** Script Generador de Encuentros *******************
template author: Inquisidor
script name: sgeCryptBoss
script author: Inquisidor
names of the areas this script is asociated with: camino del este de benzor hacia el troll ebrio
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE( 1.3 ,10.0 );
    RS_setFaccion( datosSGE, STANDARD_FACTION_HOSTILE );

        string arregloDMDs = RS_ArregloDMDs_sumar( ADE_Planar_Demon_get(), ADE_Planar_Devil_get() );

        RS_generarSolitario( datosSGE, arregloDMDs, 1.0, 0.5 );

}
