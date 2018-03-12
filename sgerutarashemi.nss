/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeRutaRashemi
script author: Inquisidor
names of the areas this script is asociated with:
CaminoRamshei 1-5
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    switch( Random(16) ) {
        case 0:
            FGE_Humanoid_HuOutLaw( datosSGE );
            break;
        case 1:
            FGE_Humanoid_HuBarbarian( datosSGE );
            break;
        case 3:
            FGE_Humanoid_HOrcOutLaw( datosSGE );
            break;
        case 4:
            FGE_Humanoid_WElfTribe( datosSGE );
            break;
        default:
            RS_generarMezclado( datosSGE, FGE_Quebradas_getVariado() );
            break;
    }
}
