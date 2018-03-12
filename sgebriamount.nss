/****************** Script Generador de Encuentros -
COMPUESTO****************
template author: Inquisidor
script name: sgebriamount
script author: Inquisidor
names of the areas this script is asociated with:
Bria Montes Gemelos 1-2-3
Trondor Montes 6-7-8-9-11-12
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 6, 6 );

    // si el encuentro cae hacia el sur-oeste del area
    if( seccionEncuentro == Location_SECCION_SUR_OESTE ) {
        FGE_Giant_Ogro( datosSGE );
    }
    // si el encuentro no cae hacia el sur-oeste del area
    else {
        datosSGE.faccionId = STANDARD_FACTION_HOSTILE;

        // y es de dia
        if( GetIsDay() ) {
            RS_generarMezclado( datosSGE,
                FGE_BosqueCalidoDia_getVariado()
                + ADE_Bestias_Hills_getVariado()
            );
        }
        // y es de noche
        else {
            // y el encuentro cae al nor-oeste del area
            if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
                FGE_Humanoid_TrasgoCaverna( datosSGE );
            }
            // y el encuentro no cae al nor-oeste del area
            else {
                RS_generarMezclado( datosSGE,
                    FGE_BosqueCalidoNoche_getVariado()
                    + ADE_Bestias_Hills_getVariado()
                );
            }
        }
    }
}








