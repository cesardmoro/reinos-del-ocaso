/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenriverboca
script author: Lobofiel
names of the areas this script is asociated with:
Rio Benzor, Desembocadura
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 7, 7 );

    // si cae en el OESTE del area =
    //1) Trasgos
    //2) Ambiente Pradera
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) == 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
        else {
            FGE_Humanoid_Trasgo( datosSGE );
        }
    }

    // si el encuentro cae en el RESTO del area = Semiorcos
    else {
            FGE_Humanoid_HOrcOutLaw( datosSGE );
    }
}
