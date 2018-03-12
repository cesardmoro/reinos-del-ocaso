/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgesusurroso4
script author: Lobofiel
names of the areas this script is asociated with:
Bosque de los Susurros (O4) , Tierras del Clan Orco del Colmillo Rojo (ahora yuanti)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector ESTE del area = Ambiente Bosque Calido
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) != 0 ) {
        RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
    }

    // si el encuentro cae en el sector OESTE del area =
    //1) Yuanti
    //2) Ambiente Bosque Calido
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_BosqueCalido_getVariado());
        }
        else {
            FGE_Humanoid_YuanTi( datosSGE );
        }
    }
}

