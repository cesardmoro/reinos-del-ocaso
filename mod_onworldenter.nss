#include "entradas"
#include "IPS_Pj_inc"
#include "Location_tools"
#include "Competencias_inc"

// Script llamado cuando un personaje controlado por un jugador o DM entra a un �rea del mundo por primera vez desde que entr� al m�dulo.
// O sea que esta funcion es llamada una sola vez por cada vez que un jugador entra al m�dulo, y es llamada apenas entra al primer �rea que se concidere parte del mundo.
// El �rea de inicio y areas de servicio no se concideran �reas del mundo y por ende no disparan el evento que ejecuta esta funcion.
// OBJECT_SELF puede ser solo el personaje de un jugador, o el avatar de un DM. No puede ser ninguna criatura incluso aunque este controlada por un jugador o DM.
void main();
void main() {
    object pc = OBJECT_SELF;

    if( !GetIsDM(pc) ) {
        Entradas_ajustarVida( pc );
        IPS_Pj_onWorldEnter( pc );
        Competencias_onEnter( pc );
    }
}
