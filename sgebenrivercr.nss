/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebenrivercr
script author: Inquisidor
names of the areas this script is asociated with:
Rio Benzor - Puente del Camino del Este
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    int seccion = Location_dicernirSeccion( GetPositionFromLocation( datosSGE.ubicacionEncuentro ), 5, 5 );
    // si el ecuentro cae en la mitad este del area =
    // 1) Amb.Pradera
    // 2) Amb.Pantano
    if( (seccion & Location_SECCION_ES_ESTE_BIT) != 0 ) {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
        else {
            RS_generarMezclado( datosSGE,FGE_Pantano_getVariado());
        }
    }

    // si el encuentro cae en el cuarto sur-oeste del area = Undead
    else if ( seccion == Location_SECCION_SUR_OESTE ) {
        RS_generarGrupo( datosSGE,FGE_Undead_get());
    }

    // si el encuentro cae en el cuarto nor-oeste del area =
    // 1) Trasgos
    // 2) Amb.Pradera
    else {
        if (Random (2) == 0){
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
        else {
            FGE_Humanoid_Trasgo( datosSGE );
        }
    }
}

