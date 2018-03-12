/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgetrollway1
script author: Lobofiel
names of the areas this script is asociated with:
Ruta del Troll 1
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto NORESTE del area =
    // 1) Gnolls
    // 2) Ambiente Pantano
    if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
        }
        else {
            FGE_Humanoid_Gnoll( datosSGE );
        }
    }
    else if( seccionEncuentro == Location_SECCION_NOR_OESTE ) {
        if( Random(3)==0 )
            RS_generarGrupo( datosSGE, FGE_NPC_mercenary_get() );
        else
            RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
    }

    // si el encuentro cae en el RESTO del area =
    // Ambiente Pantano
    else {
        RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
    }
}
