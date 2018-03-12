/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeoasiskorran
script author: Lobofiel
names of the areas this script is asociated with:
Desierto del Sur, Oasis de Korran  (Tribu de la Bestia de Trueno)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 3, 3 );

    // si cae en el cuarto NOROESTE del area = ?
    if( seccionEncuentro == Location_SECCION_NOR_OESTE ) {
        int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 7, 7 );

    // si cae sobre el OASIS =
    // Human Barbarians
        if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
                FGE_Humanoid_HuBarbarian( datosSGE );
        }
        // si el encuentro cae en el RESTO del area NOROESTE =
        // 1) Ambiente Desierto
        // 2) Human Barbarians
        else {
            if (Random (2) == 0){
                RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
            }
            else {
                FGE_Humanoid_HuBarbarian( datosSGE );
            }
        }
    }
    // si cae en el MARGEN SURESTE del area
    // 1) Ambiente Desierto
    // 2) Human Barbarians
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
        }
        else {
            FGE_Humanoid_HuBarbarian( datosSGE );
        }
    }
}

