/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebriapeaksC
script author: Lobofiel
names of the areas this script is asociated with:
Picos Gemelos de Bria, Centro
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector ESTE del area =
    //1) Wild Elf Barbarians
    //2) Ambiente Mountain
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) != 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Montanas_getVariado());
        }
        else {
            FGE_Humanoid_WElfTribe( datosSGE );
        }
    }

    // si el encuentro cae en el sector OESTE del area =
    //1) Gnolls
    //2) Ambiente Mountain
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Montanas_getVariado());
        }
        else {
            FGE_Humanoid_Gnoll( datosSGE );
        }
    }
}
