/************* Script Generador de Encuentros - Variado ***************
template author: Inquisidor
script name: sgeBosqueBenzor
script author: Inquisidor
names of the areas this script is asociated with: bosques de benzor
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    if( GetIsDay() )
        RS_generarMezclado( datosSGE,
            FGE_Animal_BosqueDiurno_getVariado()
        );
    else
        RS_generarMezclado( datosSGE,
            FGE_Animal_BosqueNocturno_getVariado()
        );

}
