/******************* RdO area civilizada - onAreaExit event handler ************
Autores: Inquisidor y Dragoncin
*******************************************************************************/

#include "RS_onExit"
#include "Skills_sinergy"
#include "DeadMagic_inc"
#include "Nigromancia_inc"

// si haces un cambio a este script, no olvides hacerlo tambien en el script "def_area_onExit"
void main() {
    object exitingObject = GetExitingObject();

    RS_onExit( exitingObject );

    if (GetIsPC(exitingObject) && !GetIsDM(exitingObject)) {
        Skills_Sinergy_areaOnExit( exitingObject );
        Nigromancia_onAreaExit( exitingObject );
    }

    MagiaMuerta_onAreaExit( exitingObject );

}

