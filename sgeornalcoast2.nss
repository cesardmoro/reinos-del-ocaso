/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalcoast2
script author: Lobofiel
names of the areas this script is asociated with:
Costa de Ornal 2, (Territorio Trasgos del Garrote Sangriento)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector NORTE del area = Ambiente Pradera
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) != 0 ) {
        RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
    }

    // si el encuentro cae en el sector SUR del area =
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

