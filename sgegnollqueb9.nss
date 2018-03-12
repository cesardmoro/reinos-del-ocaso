/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgegnollqueb9
script author: Lobofiel
names of the areas this script is asociated with:
Quebradas del Gnoll Ladrador 9
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector OESTE del area =
    // 1) Orcos
    // 2) Ambiente Quebradas
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) == 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_Orco( datosSGE );
        }
    }

    // si el encuentro cae en el sector NORESTE del area =
    // 1) Gnolls
    // 2) Ambiente Quebradas
    else if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_Gnoll( datosSGE );
        }
    }

    // si el encuentro cae en el resto del area =
    // Ambiente Quebradas
    else {
        RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
    }
}
