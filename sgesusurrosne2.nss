/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgesusurrosNE2
script author: Lobofiel
names of the areas this script is asociated with:
Bosque de los Susurros, NE2 (Tribu del Aguila)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto NORESTE del area = Wild Elf Barbarian
    if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        FGE_Humanoid_WElfTribe( datosSGE );
    }

    // si el encuentro cae en el RESTO del area =
    // 1) Ambiente Bosque Calido
    // 2) Wild Elf Barbarian
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
        }
        else {
            FGE_Humanoid_WElfTribe( datosSGE );
        }
    }
}

