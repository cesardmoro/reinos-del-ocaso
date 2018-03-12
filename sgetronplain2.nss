/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeTronPlain2
script author: Lobofiel
names of the areas this script is asociated with:
Trondor Plains 2
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto SUROESTE del area =
    //1) Orcos
    //2) Ambiente Bosque Calido
    if( seccionEncuentro == Location_SECCION_SUR_OESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
        else {
            FGE_Humanoid_Orco( datosSGE );
        }
    }

    // si el encuentro cae en el RESTO del area = Ambiente Bosque Calido
    else {
        RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
    }
}

