/****************** RdO area civilizada - onAreaEnter event handler ************
version 1.0: Inquisidor
version 1.1-1.3: Dragoncin - agregado de las llamadas a Skills_Sinergy_areaOnEnter(..), Horses_areaOnEnter(..) y Nigromancia_onAreaEnter(..)
version 1.4: merge con las entradas a las posadas que spawnean mercenarios.
*******************************************************************************/

#include "RS_onEnter"
#include "SPC_inc"
#include "PCT_area_inc"
#include "Skills_sinergy"
#include "Horses_inc"
#include "Mod_inc"
#include "Muerte_inc"
#include "DeadMagic_inc"
#include "Nigromancia_inc"
#include "Mercenario_inc"

void main() {
    object enteringObject = GetEnteringObject();
    if( GetIsPC( enteringObject ) ) {
        Mod_onPcEntersArea( enteringObject ); // debe ser lo primero que se ejecuta cuando un Pc entra a un área.
        RS_onPcEntersArea( enteringObject );

        if( !GetIsDM( enteringObject ) ) {
            SisPremioCombate_onPjEnterArea( enteringObject );

            Muerte_onPjEntersArea( enteringObject );

            Skills_Sinergy_areaOnEnter( enteringObject );

            PerceptionSys_onPjEnterArea( enteringObject );

            if (GetLocalInt(OBJECT_SELF, "seguro") == TRUE)
                SendMessageToPC(enteringObject, "Este area es segura para desloguear");

            Nigromancia_onAreaEnter( enteringObject );

            Mercenario_onPjEntersTavern( enteringObject );
        }
    }

    MagiaMuerta_onAreaEnter( enteringObject );

    Horses_areaOnEnter( enteringObject );
}

