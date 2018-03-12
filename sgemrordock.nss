/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgedesoswam5y8
script author: Lobofiel
names of the areas this script is asociated with:
Pantanos de la Desolacion 5 y 8, Territorio Lizardfolk
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 2 );

    // si cae en el NORTE del area = Guardia de Mror
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) != 1 ) {
        FGE_Guardia_Mror( datosSGE );
    }

    // si el encuentro cae en el RESTO del area = NADA
}
