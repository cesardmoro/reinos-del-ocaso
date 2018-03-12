/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenmineroad
script author: Lobofiel
names of the areas this script is asociated with:
Benzor Mine Road (1)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector NORTE del area = Ambiente Colinas
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) != 0 ) {
        RS_generarMezclado( datosSGE,FGE_Colinas_getVariado());
    }

    // si el encuentro cae en el sector SUR del area =
    //1/3) Human Bandits
    //2/3) Ambiente Colinas
    else {
        if (Random (3) == 0){
            FGE_Humanoid_HuOutLaw( datosSGE );
        }
        else {
            RS_generarMezclado( datosSGE,FGE_Colinas_getVariado());
        }
    }
}
