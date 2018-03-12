/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenzorwood4y8
script author: Lobofiel
names of the areas this script is asociated with:
Bosque de Benzor 4 y 8
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector ESTE del area =
    // 1) Orcos
    // 2) Ambiente Bosque Templado
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) != 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_BosqueTemplado_getVariado());
        }
        else {
            FGE_Humanoid_Orco( datosSGE );
        }
    }

    // si el encuentro cae en el sector OESTE del area =
    // Ambiente Bosque Templado
    else {
        RS_generarMezclado( datosSGE,FGE_BosqueTemplado_getVariado());
    }
}

