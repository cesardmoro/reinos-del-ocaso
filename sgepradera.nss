/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgepradera
script author: Inquisidor y Lobofiel
names of the areas this script is asociated with:

********************************************************************************/
#include "RS_fge_inc"

void main()
{
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    float faeMaximo;
    if( datosSGE.dificultadEncuentro <= 4 )
        faeMaximo = 0.5;
    else if( datosSGE.dificultadEncuentro == 5 )
        faeMaximo = 0.7;
    else
        faeMaximo = 1.1;

    RS_generarMezclado( datosSGE, FGE_Pradera_getVariado(), faeMaximo );
}
