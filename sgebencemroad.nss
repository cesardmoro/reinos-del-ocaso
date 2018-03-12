/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebencemroad
script author: Lobofiel
names of the areas this script is asociated with:
Benzor - Camino del Cementerio
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 6 );

    // si cae en la mitad OESTE del area = Ambiente Quebradas
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) == 0 ) {
        RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
    }

    // si el encuentro cae en el RESTO del area =
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

