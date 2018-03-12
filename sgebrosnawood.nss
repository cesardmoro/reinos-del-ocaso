/****************** Script Generador de Encuentros -
COMPUESTO****************
template author: Inquisidor
script name: sgebrosnawood
script author: Inquisidor
names of the areas this script is asociated with:
Brosna, bosque y rural
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // y si es de dia
    if( GetIsDay() ) {
        RS_generarMezclado( datosSGE,
            FGE_Animal_BosqueDiurno_getVariado()
        );
    }
    // y si es de noche
    else {
        RS_generarMezclado( datosSGE,
            FGE_Animal_BosqueNocturno_getVariado()
        );
    }
}









/*
BosqueNoche
BosqueDia
HGiant
Ogres
UndeadSkel
UndeadFan
*/

/*     NUEVO!!!

Bosque Dia incluye Osos Legend

HGiant
gnthill001           Hill Giant D&D CR7
gnthill002barb3      Hill Giant D&D CR9 (barbarian 3)
gnthill002bar6       Hill Giant D&D CR11 (barbarian 6)
*/
