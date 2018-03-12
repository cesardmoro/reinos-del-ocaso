/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalcoast3
script author: Lobofiel
names of the areas this script is asociated with:
Costa de Ornal 3, (Territorio Trasgos del Garrote Sangriento)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 6, 6 );

    // si cae en el cuarto SURESTE del area = Trasgos
    if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
        FGE_Humanoid_Trasgo( datosSGE );
    }

    // si el encuentro cae en el RESTO del area =
    // 1) Ambiente Pradera
    // 2) Trasgos
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
        else {
            FGE_Humanoid_Trasgo( datosSGE );
        }
    }
}

