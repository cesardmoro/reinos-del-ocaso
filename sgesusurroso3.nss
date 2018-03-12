/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgesusurroso3
script author: Lobofiel
names of the areas this script is asociated with:
Bosque de los Susurros (O3) , Tierras del Clan Orco del Colmillo Rojo (ahora Yuan Ti)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // discernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto SURESTE del area = Yuanti
    if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
        FGE_Humanoid_YuanTi( datosSGE );
    }

    // si el encuentro cae en el RESTO del area =
    // 1) Ambiente Bosque Calido
    // 2) Yuanti
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
        }
        else {
            FGE_Humanoid_YuanTi( datosSGE );
        }
    }
}
