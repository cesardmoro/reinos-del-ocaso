/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenhilloccs
script author: Lobofiel
names of the areas this script is asociated with:
Planicie de Benzor, colinas Occ. (Sur) - Trasgos de la Calavera
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto NOROESTE del area = Trasgoides
    if( seccionEncuentro == Location_SECCION_NOR_OESTE ) {
        FGE_Humanoid_Trasgo( datosSGE);
    }

    // si el encuentro cae en el RESTO del area =
    //1) Trasgoides
    //2) AMBIENTE COLINAS
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Colinas_getVariado());
        }
        else {
            FGE_Humanoid_Trasgo( datosSGE );
        }
    }
}
