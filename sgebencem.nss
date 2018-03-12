/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebencem
script author: Lobofiel
names of the areas this script is asociated with:
Benzor - Cementerio
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 8, 2 );

    // si cae en el cuarto NORESTE del area = ?
    if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae sobre el CEMENTERIO = Cementerio
        if( seccionEncuentro == Location_SECCION_SUR_OESTE ) {
            RS_generarGrupo( datosSGE, FGE_Undead_get() );
        }
        // si el encuentro cae en el RESTO del area NORESTE =
        // 1) Ambiente Quebradas
        // 2) Kobolds
        else {
            if (Random (2) == 0){
                RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
            }
            else {
                FGE_Humanoid_Kobold( datosSGE );
            }
        }
    }
    // si cae en el MARGEN SUROESTE del area = Ambiente Quebradas
    else {
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
    }
}

