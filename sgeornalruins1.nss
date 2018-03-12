/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalruins1
script author: Lobofiel
names of the areas this script is asociated with:
Macizo Ornal, Ruinas (zona de cavernas)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector SUR del area = Ambiente Bosque Calido
    // 1) AMBIENTE QUEBRADAS
    // 2) Undead
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) == 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            RS_generarGrupo( datosSGE, FGE_Undead_get());
        }
    }

    // si el encuentro cae en el sector NORTE del area = Undead
    else {
        RS_generarGrupo( datosSGE, FGE_Undead_get());
    }
}
