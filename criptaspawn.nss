/************** Script Generador de Encuentros - Grupales simples *******************
template author: Inquisidor
script name: criptaSpawn
script author: Inquisidor
names of the areas this script is asociated with: criptas del cementerio de Benzor y del rio Benzor
********************************************************************************/
#include "RS_sgeTools"
#include "RS_ADE"

void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    float faeZombies = RS_generarGrupo( datosSGE, ADE_Undead_Zombi_getMelee(), 0.5, 0.15 );

    RS_generarGrupo( datosSGE, ADE_Undead_EsqueletoH_getMelee(), 1.0 - faeZombies );

}

