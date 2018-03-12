/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgekorundunes2
script author: Lobofiel
names of the areas this script is asociated with:
Desierto del Sur, Korunda Dunes 4
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto NORESTE del area =
    // 1) Human Barbarian
    // 2) Ambiente Desierto
    if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
        }
        else {
            FGE_Humanoid_HuBarbarian( datosSGE );
        }
    }

    // si cae en el cuarto SURESTE del area =
    // 1) Stinger
    // 2) Ambiente Desierto
    if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
        }
        else {
            FGE_Humanoid_Stinger( datosSGE );
        }
    }

    // si el encuentro cae en el RESTO del area =
    // Ambiente Desierto
    else {
        RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
    }
}
