/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebencostafaro
script author: Lobofiel
names of the areas this script is asociated with:
Costa de Benzor, Ruinas del Viejo Faro (ext, territorio trasgo)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto SURESTE del area = Trasgos
    if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
            RS_generarGrupo( datosSGE, FGE_Undead_get());
    }

    // si cae en el cuarto NORESTE del area =
    //1)Trasgos
    //2)Ambiente Pradera
    else if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
        else {
            FGE_Humanoid_Trasgo( datosSGE );
        }
    }

    // si el encuentro cae en el RESTO del area = Ambiente Pradera
    else {
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
    }
}

