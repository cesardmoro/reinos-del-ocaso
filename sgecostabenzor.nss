/****************** Script Generador de Encuentros -
COMPUESTO****************
template author: Inquisidor
script name: sgecostabenzor
script author: Inquisidor
names of the areas this script is asociated with:
Costa de Benzor x4
Costa de Ornal x3
********************************************************************************/

#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si el encuentro cae hacia el norte del area
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) != 0 ) {
        FGE_Humanoid_Trasgo( datosSGE );
    }
    // si el encuentro cae hacia el sur del area
    else {
        if( GetLocalInt( OBJECT_SELF, RS_dadoCicloEstado_VN ) < 100 )
            FGE_Humanoid_HOrcOutLaw( datosSGE );
        else
            RS_generarMezclado( datosSGE, FGE_BosqueTemplado_getVariado() );
    }
}









