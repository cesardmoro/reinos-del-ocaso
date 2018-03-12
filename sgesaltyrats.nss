/************** Script Generador de Encuentros - Grupales simples *******************
template author: Inquisidor
script name:  sgeSaltyRats
script author:  Lobofiel
names of the areas this script is asociated with:
Benzor - El Perro Salado - Sotano
--- Solo mediante quest de limpieza ---
Puede ser rehusado en alguna otra posada/granero
********************************************************************************/
#include "RS_sgeTools"
#include "RS_ade"

void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    string arregloDMDs;
    arregloDMDs = ADE_Animales_Ratas_getVariado();
    RS_generarGrupo( datosSGE, arregloDMDs );

}

