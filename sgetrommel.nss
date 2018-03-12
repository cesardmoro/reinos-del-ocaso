/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgeTromel
script author: Inquisidor
names of the areas this script is asociated with:
?
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );
    switch( seccionEncuentro ) {

        case Location_SECCION_SUR_OESTE:
        case Location_SECCION_NOR_ESTE:
            RS_generarMezclado( datosSGE,
                ADE_Benzor_Trommel_getVariado()
            );
            break;

        case Location_SECCION_SUR_ESTE:
            FGE_Humanoid_Minotauro( datosSGE );
            break;

        case Location_SECCION_NOR_OESTE:
            FGE_Giant_Ogro( datosSGE );
            break;
    }
}


