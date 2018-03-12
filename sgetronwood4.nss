/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeTronWood4
script author: Lobofiel
names of the areas this script is asociated with:
Trondor Woods 4, Cementery
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 4, 3 );

    // si cae en el cuarto NORESTE del area = ?
    if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 2, 8 );

    // si cae sobre el CEMENTERIO = Cementerio
        if( seccionEncuentro == Location_SECCION_SUR_OESTE ) {
            RS_generarGrupo( datosSGE,FGE_Undead_get());
        }
        // si el encuentro cae en el RESTO del area NORESTE =
        // 1) Ambiente Bosque Calido
        // 2) Orcos
        else {
            if (Random (2) == 0){
                RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
            }
            else {
                FGE_Humanoid_Orco( datosSGE );
            }
        }
    }
    // si cae en el MARGEN SUROESTE del area = Ambiente Bosque Calido
    else {
            RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
    }
}

