/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebeneplainroad
script author: Lobofiel
names of the areas this script is asociated with:
Planicie de Benzor, Llanura Oriental, Ruta del Este (1)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si cae en el cuarto NOROESTE del area =
    //1/3) Human Bandits
    //2/3) Ambiente Pradera
    if( seccionEncuentro == Location_SECCION_NOR_OESTE ) {
        if (Random (3) == 0){
            FGE_Humanoid_HuOutLaw( datosSGE );
        }
        else {
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
    }

    // si el encuentro cae en el RESTO del area = Ambiente Pradera
    // 1) Trasgos
    // 2) Ambiente Pradera
    else {
        if (Random (2) == 0){
            FGE_Humanoid_Trasgo( datosSGE );
        }
        else {
            RS_generarMezclado( datosSGE,FGE_Pradera_getVariado());
        }
    }
}
