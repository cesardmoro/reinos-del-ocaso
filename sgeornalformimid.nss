/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalformimid
script author: Inquisidor
names of the areas this script is asociated with:
Cavernas del Macizo Ornal - Colonia Formicida (caverna de entrada)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el NORTE del area =
    //1) Formicidas
    //2) Ambiente Quebradas
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) != 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Planar_Formicida( datosSGE );
        }
    }

    // si el encuentro cae en el RESTO del area = Formicidas
    else {
        FGE_Planar_Formicida( datosSGE );
    }
}

