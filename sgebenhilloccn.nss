/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenhilloccn
script author: Lobofiel
names of the areas this script is asociated with:
Planicie de Benzor, colinas Occ. (Norte) - Trasgos de la Calavera
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector SUR del area = Ambiente Bosque Calido
    // 1) AMBIENTE COLINAS
    // 2) Trasgos
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) == 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Colinas_getVariado());
        }
        else {
            FGE_Humanoid_Trasgo( datosSGE );
        }
    }

    // si el encuentro cae en el sector NORTE del area = AMBIENTE COLINAS
    else {
        RS_generarMezclado( datosSGE,FGE_Colinas_getVariado());
    }
}
