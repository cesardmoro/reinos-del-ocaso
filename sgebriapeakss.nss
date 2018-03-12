/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebriapeaksS
script author: Lobofiel
names of the areas this script is asociated with:
Picos Gemelos de Bria, Sur
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector SUR del area =
    // Ambiente Mountain
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) == 0 ) {
        RS_generarMezclado( datosSGE,FGE_Montanas_getVariado());
    }

    // si el encuentro cae en el sector NORESTE del area =
    // 1) Wild Elf Barbarian
    // 2) Ambiente Mountain
    else if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Montanas_getVariado());
        }
        else {
            FGE_Humanoid_WElfTribe( datosSGE );
        }
    }

    // si el encuentro cae en el resto del area =
    // 1) Gnolls
    // 2) Ambiente Mountain
    else  {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Montanas_getVariado());
        }
        else {
            FGE_Humanoid_Gnoll( datosSGE );
        }
    }
}
