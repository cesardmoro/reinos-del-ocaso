/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalmacB
script author: Lobofiel
names of the areas this script is asociated with:
Macizo Ornal B,
(Territorio Trasgos del Garrote Sangriento)
(Territorio Orcos del Ojo Ciego)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto SURESTE del area =
    // 1) Ambiente Quebradas
    // 2) Trasgos
    if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_Trasgo( datosSGE );
        }
    }

    // si cae en el cuarto NOROESTE del area =
    // 1) Ambiente Quebradas
    // 2) Orcos
    if( seccionEncuentro == Location_SECCION_NOR_OESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_Orco( datosSGE );
        }
    }

    // si el encuentro cae en el RESTO del area = Ambiente Quebradas
    else {
        RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
    }
}

