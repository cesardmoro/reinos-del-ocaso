/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgekoruncape4
script author: Lobofiel
names of the areas this script is asociated with:
Desierto del Sur, Korunda Cape 4 (Fortaleza)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto SURESTE del area =
    // Goblins
    if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
        FGE_Humanoid_Trasgo( datosSGE );
    }

    // si el encuentro cae en el RESTO del area =
    // 1) Goblins
    // 2) Ambiente Desierto
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Desierto_getVariado());
        }
        else {
            FGE_Humanoid_Trasgo( datosSGE );
        }
    }
}
