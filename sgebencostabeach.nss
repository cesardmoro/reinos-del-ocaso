/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebencostabeach
script author: Lobofiel
names of the areas this script is asociated with:
Costa de Benzor, Playas del Este (territorio trasgo)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 4, 5 );

    // si cae en el sector ESTE del area = Trasgos
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) != 0 ) {
        FGE_Humanoid_Trasgo( datosSGE );
    }

    // si el encuentro cae en el sector OESTE del area =
    //1) Trasgos
    //2) Ambiente Pradera
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
        else {
        FGE_Humanoid_Trasgo( datosSGE );
        }
    }
}

