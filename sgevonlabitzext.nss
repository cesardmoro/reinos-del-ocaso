/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgevonlabitzext
script author: Lobofiel
names of the areas this script is asociated with:
Planicie de Benzor, Llanura Oriental, Mansion Von Labitz (ext)
(Saltea el Area de la Mansion)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 9, 4 );

    // si cae en el sector SUR del area =
    // 1) Ambiente Pradera
    // 2) Trasgos
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) == 0 ) {
        if (Random (2) == 0){
            FGE_Humanoid_Trasgo( datosSGE );
        }
        else {
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
    }

    // si cae en el sector OESTE del area = Ambiente Pradera
    else if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) == 0 ) {
        RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
    }

    // si cae en el cuarto NORESTE del area = Saltea Area Mansion
    else if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 6, 8 );

    // si cae en el sector ESTE del area = Ambiente Pradera
        if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) != 0 ) {
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }

    // si cae en el sector NORTE del area = Ambiente Pradera
        else if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) != 0 ) {
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
    }
}

