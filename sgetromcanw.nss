/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgetromcanW
script author: Lobofiel
names of the areas this script is asociated with:
Paso de Trommel, Canones Occ., Tribu del Oso Azul
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 6, 4 );

    // si cae en el cuarto NORESTE del area = Human Barbarian
    if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        FGE_Humanoid_HuBarbarian( datosSGE );
    }

    // si el encuentro cae en el RESTO del area =
    // 1) Ambiente Quebradas
    // 2) Human Barbarian
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_HuBarbarian( datosSGE );
        }
    }
}

