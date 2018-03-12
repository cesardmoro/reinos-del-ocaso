/************** Script Generador de Encuentros - Grupales simples *******************
template author: Inquisidor
script name: sgebenzorcript
script author: lobofiel
names of the areas this script is asociated with:
Benzor - Cementerio - Criptas (x6)
Rio Benzor - Criptas (x4)
********************************************************************************/
#include "RS_sgeTools"
#include "RS_ADE"


void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    string arregloDMDs;
    arregloDMDs = ADE_Undead_EsqueletoH_getMelee();
    RS_generarGrupo( datosSGE, arregloDMDs );

}


