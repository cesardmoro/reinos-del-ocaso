/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgemrordunes3
script author: Lobofiel
names of the areas this script is asociated with:
Desierto del Sur, Mror Dunes 3
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector NORTE del area = Ambiente Desierto
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) != 0 ) {
        RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
    }

    // si el encuentro cae en el sector SUR del area =
    //1) Human Barbarians
    //2) Ambiente Desierto
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
        }
        else {
            FGE_Humanoid_HuBarbarian( datosSGE );
        }
    }
}
