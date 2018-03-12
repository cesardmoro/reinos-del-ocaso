/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: SGEMRORTEMPLE
script author: Lobofiel
names of the areas this script is asociated with:
MROR, Barrio del Palacio
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 8, 2 );

    // si cae en el cuarto NORESTE del area = Guardia de Mror
    if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        FGE_Guardia_Mror( datosSGE );
    }
    // si el encuentro cae en el RESTO del area = NADA
}
