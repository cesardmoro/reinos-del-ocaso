/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgeornalmacE
script author: Lobofiel
names of the areas this script is asociated with:
Macizo Ornal D, (Territorio Orcos del Ojo Ciego)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el sector NORTE del area =
    // 1) Orcos
    // 2) Ambiente Quebradas
    if( (seccionEncuentro & Location_SECCION_ES_NORTE_BIT) != 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Quebradas_getVariado());
        }
        else {
            FGE_Humanoid_Orco( datosSGE );
        }
    }

    // si el encuentro cae en el sector SUR del area = Ambiente Quebradas
    else {
        if( Random(5) == 0 )
            RS_generarGrupo( datosSGE, FGE_NPC_mercenary_get() );
        else
            RS_generarMezclado( datosSGE, FGE_Quebradas_getVariado() );
    }
}

