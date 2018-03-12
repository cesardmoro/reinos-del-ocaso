/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgedesoswam12
script author: Lobofiel
names of the areas this script is asociated with:
Pantanos de la Desolacion 12, Territorio Lizardfolk
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector SUR del area = Ambiente Pantano
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) == 0 ) {
        RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
    }

    // si el encuentro cae en el sector NORTE del area =
    //1) Lizardmen
    //2) Ambiente Pantano
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
        }
        else {
            FGE_Humanoid_Lizardmen( datosSGE );
        }
    }
}
