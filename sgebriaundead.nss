/****************** Script Generador de Encuentros -
COMPUESTO****************
template author: Inquisidor
script name: sgebriaundead
script author: Inquisidor
names of the areas this script is asociated with:
Bosque de Bria Norte 3
Bosque de Bria Este 5
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // y si es de dia
    if( GetIsDay() ) {
        RS_generarMezclado( datosSGE, FGE_BosqueCalidoDia_getVariado() );
    }
    // y si es de noche
    else {
        // dicernir en que seccion del area cae el encuentro
        int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 6, 6 );

        // si el encuentro cae hacia el sur-oeste del area
        if( seccionEncuentro == Location_SECCION_SUR_OESTE ) {
            FGE_Undead_Esqueleto( datosSGE );
        }
        // si el encuentro no cae hacia el sur-oeste del area
        else {
            RS_generarMezclado( datosSGE, FGE_BosqueCalidoNoche_getVariado() );
        }
    }
}















