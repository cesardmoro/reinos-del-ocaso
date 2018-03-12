/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgebenzorkobl
script author:  lobofiel
names of the areas this script is asociated with:
Enclaves Kobolds cercanos a Benzor
********************************************************************************/
#include "RS_sgeTools"
#include "RS_ade"

void main() {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    float faeCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_Kobold_getCaster(), 0.3, 0.2 );   // 30% del poder del encuentro estaria comprendido por casters

    RS_generarGrupo( datosSGE, ADE_Humanoid_Kobold_getMelee(), 1.0 - faeCasters );  // el resto del poder del encuentro estaria comprendido por fighters

}

