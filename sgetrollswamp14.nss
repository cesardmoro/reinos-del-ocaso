/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgetrollswamp14
script author: Lobofiel
names of the areas this script is asociated with:
Pantano del Troll 14 (Ruinas del Templo de Ilmater)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro =Location_dicernirSeccion ( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 7, 5 );

    // si cae en el cuarto SUROESTE del area =
    // 1) Half Orc Barbarians
    // 2) Ambiente Pantano
    if( seccionEncuentro == Location_SECCION_SUR_OESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
        }
        else {
            FGE_Humanoid_HOrcOutLaw( datosSGE );
        }
    }

    // si cae en el cuarto NOROESTE del area =
    // Ambiente Pantano
    else if( seccionEncuentro == Location_SECCION_NOR_OESTE ) {
        RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
    }

    // si el encuentro cae en el RESTO del area =
    // Ambiente Pantano
    // Undeads
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
        }
        else {
            RS_generarGrupo( datosSGE, FGE_Undead_get() );
        }
    }
}
