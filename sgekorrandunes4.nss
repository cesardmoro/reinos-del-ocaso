/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgekorrandunes4
script author: Lobofiel
names of the areas this script is asociated with:
Desierto del Sur, Dunas de Korran 4  (Aguijoneadores de las Ruinas del Reino Antiguo)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 2, 2 );

    // si cae en el cuarto NOROESTE del area = ?
    if( seccionEncuentro == Location_SECCION_NOR_OESTE ) {
        int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 8, 8 );

    // si cae sobre las RUINAS =
    // Aguijoneadores
        if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
                FGE_Humanoid_Stinger( datosSGE );
        }
        // si el encuentro cae en el RESTO del area NOROESTE =
        // 1) Ambiente Desierto
        // 2) Aguijoneadores
        else {
            if (Random (2) == 0){
                RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
            }
            else {
                FGE_Humanoid_Stinger( datosSGE );
            }
        }
    }
    // si cae en el MARGEN SURESTE del area
    // 1) Ambiente Desierto
    // 2) Aguijoneadores
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
        }
        else {
            FGE_Humanoid_Stinger( datosSGE );
        }
    }
}

