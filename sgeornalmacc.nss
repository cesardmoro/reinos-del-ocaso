/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalmacC
script author: Lobofiel
names of the areas this script is asociated with:
Macizo Ornal C, (Territorio Trasgos del Garrote Sangriento y Bandidos Semiorcos)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector ESTE del area =
    // 1) Trasgos
    // 2) Ambiente Quebradas
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) != 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_Trasgo( datosSGE );
        }
    }

    // si el encuentro cae en el sector OESTE del area =
    //1/3) Half Orc Outlaws
    //2/3) Ambiente Quebradas
    else {
        if (Random (3) == 0){
            FGE_Humanoid_HOrcOutLaw( datosSGE );
        }
        else {
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
    }
}

