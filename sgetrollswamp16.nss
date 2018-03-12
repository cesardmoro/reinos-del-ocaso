/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgetrollswamp16
script author: Lobofiel
names of the areas this script is asociated with:
Pantano del Troll 16 (Aldea de la Tribu de la Sierpe Negra)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 8, 5 );

    // si cae en el sector ESTE del area =
    // Half Orc Barbarians
    if( (seccionEncuentro & Location_SECCION_ES_ESTE_BIT) != 0 ) {
        FGE_Humanoid_HOrcOutLaw( datosSGE );
    }

    // si el encuentro cae en el sector OESTE del area =
    //1) Half Orc Barbarians
    //2) Ambiente Pantano
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
        }
        else {
            FGE_Humanoid_HOrcOutLaw( datosSGE );
        }
    }
}

