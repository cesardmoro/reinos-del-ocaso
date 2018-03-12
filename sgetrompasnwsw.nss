/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgetrompasNWSW
script author: Lobofiel
names of the areas this script is asociated with:
Paso de Trommel, Rio Trommel
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector ESTE del area = Ambiente Quebradas
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) != 0 ) {
        RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
    }

    // si el encuentro cae en el sector OESTE del area =
    //1) Human Barbarian
    //2) Ambiente Quebradas
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_HuBarbarian( datosSGE );
        }
    }
}

