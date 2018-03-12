/************************ Cochero on death handler ****************************
Package: Sistema de tranporte por carreta - cochero - on death handler
Autor: Inquisidor
Version: 0.1
*******************************************************************************/
#include "Cochero"

void main()
    /* On death handler del cochero */
{
//    SendMessageToPC( GetFirstPC(), "Cochero_onDeath: beign " );

    ExecuteScript("nw_c2_default7", OBJECT_SELF);

    object carretaAsociada = Cochero_getCarreta( OBJECT_SELF );
    if( carretaAsociada == OBJECT_INVALID ) // esto se cumple si muere un cochero que perdio su carreta
        return;

    location sitioDescargaPasajeros;

    switch( GetLocalInt( OBJECT_SELF, Cochero_estado_FIELD ) ) {

        case Cochero_Estado_DESCANSANDO:
            // Descargar los pasajeros de la carreta cuyo cochero muere.
            Carreta_descargarPasajeros(
                carretaAsociada,
                Carreta_getEscaleraLoc( Cochero_getUltimaEstacion( OBJECT_SELF ) )
            );

            //Programar la apropiacion de esta instancia de carreta por otro cochero en 5 minutos.
            AssignCommand( carretaAsociada, DelayCommand( 300.0, Carreta_apropiar( carretaAsociada ) ) ); // El AssignCommand es necesario para que funcione el DlayCommand en el onDeath handler.
            break;

        case Cochero_Estado_VIAJANDO:
            SpeakString( "*Los caballos descontrolados se desvian del camino. Una de las ruedas golpea contra una roca bruscamente logrando que se desenganchen los caballos y la carreta comience a volcar.*" );
            AssignCommand( carretaAsociada, DelayCommand( 5.0, Carreta_choque() ) ); // El AssignCommand es necesario para que funcione el DelayCommand en el onDeath handler.
            break;
    }
}
