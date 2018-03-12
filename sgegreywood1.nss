/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgegreywood1
script author: Inquisidor
names of the areas this script is asociated with:
Bosques de Bria, Bosque Gris 1
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto SURESTE del area =
    // Wild Elf Barbarian
    if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
        FGE_Humanoid_WElfTribe( datosSGE );
    }

    // si el encuentro cae en el RESTO del area =
    //1) Wild Elf Barbarian
    //2) Ambiente Bosque Calido
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
        }
        else {
            FGE_Humanoid_WElfTribe( datosSGE );
        }
    }
}
