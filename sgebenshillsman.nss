/************** Script Generador de Encuentros - Grupales simples *******************
template author: Inquisidor
script name: sgebenshillsman
script author: Inquisidor
names of the areas this script is asociated with:
Benzor South Hills Manantial Cave (1)
********************************************************************************/
#include "RS_sgeTools"
#include "RS_ade"


void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    switch( Random(5) ) {
        case 0:
        case 1: {
            string suma = RS_ArregloDMDs_sumar( ADE_Planar_MefitW_getVariado(), ADE_Elemental_Water_getVariado() );
            RS_generarGrupo( datosSGE, suma );
        }   break;

        case 2:
            RS_generarGrupo( datosSGE, ADE_Humanoid_Minotauro_get() );
            break;

        case 3:
            RS_generarGrupo( datosSGE, ADE_Insects_Ants_get() );
            break;

        case 4:
            RS_generarGrupo( datosSGE, ADE_Pantas_VPygmy_get() );
            break;
    }
}

