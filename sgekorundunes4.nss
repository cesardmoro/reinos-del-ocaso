/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgekorundunes4
script author: Lobofiel
names of the areas this script is asociated with:
Desierto del Sur, Korunda Dunes 4
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector OESTE del area = Ambiente Desierto
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) == 0 ) {
        RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
    }

    // si el encuentro cae en el sector ESTE del area =
    //1) Stingers
    //2) Ambiente Desierto
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
        }
        else {
            FGE_Humanoid_Stinger( datosSGE );
        }
    }
}
