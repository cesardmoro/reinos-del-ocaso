/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgebosquetemplado
script author: Inquisidor y Lobofiel
names of the areas this script is asociated with:

********************************************************************************/
#include "RS_fge_inc"

void main()
{
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    RS_generarMezclado( datosSGE,FGE_BosqueTemplado_getVariado() );
}
