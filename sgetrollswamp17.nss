/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgetrollswamp17
script author: Lobofiel
names of the areas this script is asociated with:
Pantano del Troll 17 (Torreon Perdido)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 7 );

    // si cae en el sector NORTE del area =
    // Ambiente Pantano
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) != 0 ) {
        RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
    }

    // si el encuentro cae en el sector OESTE del area =
    //1) Undeads
    //2) Ambiente Pantano
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
        }
        else {
            RS_generarGrupo( datosSGE, FGE_Undead_get() );
        }
    }
}
