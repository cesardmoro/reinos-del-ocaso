/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenshills2
script author: Inquisidor
names of the areas this script is asociated with:
Benzor South Hills 2
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector ESTE del area = Ambiente Colinas
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) != 0 ) {
        RS_generarMezclado( datosSGE,FGE_Colinas_getVariado());
    }

    // si el encuentro cae en el sector OESTE del area =
    //1) Orcos
    //2) Colinas
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Colinas_getVariado());
        }
        else {
            FGE_Humanoid_Orco( datosSGE );
        }
    }
}

