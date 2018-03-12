/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgegnollqueb2
script author: Lobofiel
names of the areas this script is asociated with:
Quebradas del Gnoll Ladrador 2 (Gnolls de Crinoscura)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto SUROESTE del area =
    // Gnolls
    if( seccionEncuentro == Location_SECCION_SUR_OESTE ) {
        FGE_Humanoid_Gnoll( datosSGE );
    }

    // si el encuentro cae en el RESTO del area =
    // 1) Gnolls
    // 2) Ambiente Quebradas
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_Gnoll( datosSGE );
        }
    }
}
