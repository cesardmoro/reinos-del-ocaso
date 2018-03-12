/********************* class Cochero - implementacion **************************
Cochero - include
Author: Inquisidor
Version: 0.1
Descripcion: define al cochero de una carreta. Su responsabilidaes son: saber
el estado de progreso del viaje o descanso, y tratar con los pasajeros.
*************************************************************************/
#include "Cochero_itf"
#include "Carreta"
#include "DateTime"
#include "Ctnr_VectorObj"



// Hace que el cochero memorice el rostro del sujeto. Solo tiene efecto si sujeto no lleva casco.
// Esta funcion es llamada cuando un sujeto paga el pasaje convirtiendolo en pasajero.
void Cochero_memorizarRostro( object this, object sujeto );
void Cochero_memorizarRostro( object this, object sujeto ) {

    // registrar el rostro si es que esta visible
    if( GetItemInSlot( INVENTORY_SLOT_HEAD, sujeto ) == OBJECT_INVALID ) {
        struct Address memoriaPagaron;
        memoriaPagaron.nbh = OBJECT_SELF;
        memoriaPagaron.path = Cochero_memoriaPagaron_FIELD;
        VectorObj_pushBack( memoriaPagaron, sujeto );
    }
}


// Da TRUE si este cochero recuerda el rostro del sujeto.
// Dado que el cochero recuerda el rostro de quienes pagan (ver conversacion "Cochero",
// llamar esta funcion sirve para averiguar si el sujeto pago el pasaje.
int Cochero_recordarRostro( object this, object sujeto );
int Cochero_recordarRostro( object this, object sujeto ) {
    struct Address memoriaPagaron;
    memoriaPagaron.nbh = OBJECT_SELF;
    memoriaPagaron.path = Cochero_memoriaPagaron_FIELD;

    int indexIterator = VectorObj_getSize( memoriaPagaron );
    while( --indexIterator >= 0 ) {
        if( sujeto == VectorObj_getAt( memoriaPagaron, indexIterator ) )
            return TRUE;
    }
    return FALSE;
}


// Hace que el cochero OBJECT_SELF olvide los rostros que recuerda.
// Esta funcion es llamada cada vez que el cochero parte de una estacion.
void Cochero_olvidarRostros();
void Cochero_olvidarRostros() {
    struct Address memoriaPagaron;
    memoriaPagaron.nbh = OBJECT_SELF;
    memoriaPagaron.path = Cochero_memoriaPagaron_FIELD;
    VectorObj_removeContents( memoriaPagaron );
}


//
void Cochero_timerHandler();


// Proceso que realiza el cochero OBJECT_SELF cuando se arriva a la estacion destino.
void Cochero_arrivarAEstacion( object estacionWaypoint );
void Cochero_arrivarAEstacion( object estacionWaypoint ) {
    object this = OBJECT_SELF;
    if( estacionWaypoint != OBJECT_INVALID ) {
        object carretaAsociada = Cochero_getCarreta( this );
        if( carretaAsociada != OBJECT_INVALID ) {
            location estacionLoc = GetLocation( estacionWaypoint );
            SetLocalLocation( this, Cochero_ultimaEstacionLoc_FIELD, estacionLoc );
            Carreta_ponerCuerpoPlaceable( carretaAsociada, estacionLoc );
            SetLocalInt( this, Cochero_estado_FIELD, Cochero_Estado_DESCANSANDO );
            location escaleraCarretaLoc = Carreta_getEscaleraLoc( estacionLoc );
            ClearAllActions(); // cancela cualquier accion que pueda evitar que se realice el siguiente JumpToLocation()
            JumpToLocation( escaleraCarretaLoc );
            Carreta_descargarPasajeros( carretaAsociada, escaleraCarretaLoc );

            struct Carreta_InfoSiguienteViaje infoSiguienteViaje = Carreta_getInfoSiguienteViaje( carretaAsociada, GetArea( estacionWaypoint ) );
            if( infoSiguienteViaje.destinoWaypoint != OBJECT_INVALID ) {
                SetLocalString( this, Cochero_destinoNombre_FIELD, infoSiguienteViaje.destinoNombre );
                SetLocalInt( this, Cochero_presio_FIELD, infoSiguienteViaje.presio );
                int fechaHoraActual = DateTime_getActual();
                SetLocalInt( this, Cochero_fechaHoraProximaPartida_FIELD, fechaHoraActual + infoSiguienteViaje.tiempoDescanso );
                DelayCommand( IntToFloat( infoSiguienteViaje.tiempoDescanso ), Cochero_timerHandler() );

// de aqui para abajo es tratamiento de errores
            } else
                PrintString( "Cochero_arrivarADestino: error 3" );
        } else
            PrintString( "Cochero_arrivarADestino: error 2" );
    } else
        PrintString( "Cochero_arrivarADestino: error 1" );
}


// Proceso que realiza el cochero 'OBJECT_SELF' al iniciar el viaje desde la estacion actual hacia la siguiente estacion.
void Cochero_partirHaciaDestino( object estacionActual );
void Cochero_partirHaciaDestino( object estacionActual ) {
    object this = OBJECT_SELF;
    object carretaAsociada = Cochero_getCarreta( this );
    if( carretaAsociada != OBJECT_INVALID ) {
        struct Carreta_InfoSiguienteViaje infoSiguienteViaje = Carreta_getInfoSiguienteViaje( carretaAsociada, estacionActual );
        if( infoSiguienteViaje.destinoWaypoint != OBJECT_INVALID ) {
            SetLocalString( this, Cochero_destinoNombre_FIELD, infoSiguienteViaje.destinoNombre );
            SetLocalObject( this, Cochero_destinoWaypoint_FIELD, infoSiguienteViaje.destinoWaypoint );
            int fechaHoraActual = DateTime_getActual();
            SetLocalInt( this, Cochero_fechaHoraArrivoDestino_FIELD, fechaHoraActual + infoSiguienteViaje.duracionViaje  );

            object cocheroWaypoint = Carreta_getCocheroWaypoint( carretaAsociada );
            if( cocheroWaypoint != OBJECT_INVALID ) {
                JumpToObject( cocheroWaypoint );
                Carreta_sacarCuerpoPlaceable( carretaAsociada );
                // olvidar rostros de los pasajeros que pagaron el pasaje
                Cochero_olvidarRostros();
                // Si hay algún pasajero dentro de la carreta, comenzar el viaje
                if( Carreta_getFirstPasajero(carretaAsociada)!= OBJECT_INVALID ) {
                    SetLocalInt( this, Cochero_estado_FIELD, Cochero_Estado_VIAJANDO );
                    DelayCommand( IntToFloat( infoSiguienteViaje.duracionViaje ), Cochero_timerHandler() );
                }
                // si no hay ningún pasajero dentro de la carreta, pasar a estado inactivo
                else {
                    SetLocalInt( this, Cochero_estado_FIELD, Cochero_Estado_INACTIVO );
                }

    // de aqui para abajo es tratamiento de errores
            } else
                PrintString( "Cochero_partirHaciaDestino: error 3" );
        } else
            PrintString( "Cochero_partirHaciaDestino: error 2" );
    } else
        PrintString( "Cochero_partirHaciaDestino: error 1" );
}


void Cochero_timerHandler() {
    object this = OBJECT_SELF;

//    SendMessageToPC( GetFirstPC(), "TimerHandler: begin "+GetName( Cochero_getCarreta(OBJECT_SELF) ) );

    if( IsInConversation( this ) || GetIsInCombat( this ) || GetIsDMPossessed( this ) ) {
//        SendMessageToPC( GetFirstPC(), "TimerHandler: delayed" );
        DelayCommand( 20.0, Cochero_timerHandler() );
    }

//    SendMessageToPC( GetFirstPC(), "TimerHandler: 1 -"+GetName( Cochero_getCarreta(OBJECT_SELF) ) );

    else switch( Cochero_getEstado( this ) ) {

        case Cochero_Estado_DESCANSANDO: {
            location ultimaEstacionLoc = GetLocalLocation( this, Cochero_ultimaEstacionLoc_FIELD );
//            SendMessageToPC( GetFirstPC(), "TimerHandler: 2 -"+GetName( Cochero_getCarreta(OBJECT_SELF) ) );
            // si el cochero esta en el area correspondiente a la ultima estacion donde se detuvo (o sea que esta todo normal), partir hacia la siguiente estacion.
            if( GetArea( this ) == GetAreaFromLocation( ultimaEstacionLoc ) ) {
                SpeakString( "Arre! *el cochero ordena a los caballos andar*" ); // esto lo ven los de afuera de la carreta
                Cochero_partirHaciaDestino( GetArea( this ) );
                DelayCommand( 1.0f, SpeakString( "Arre! *el cochero ordena a los caballos andar*" ) ); // esto lo ven los de adentro
            }
            // sino
            else { // Esto es algo excepciontal que sucede cuando el cochero esta perdido en un area distinta a la ultima estacion donde se detuvo.
                // Desasociar mutuamente este cochero de su ex carreta.
                object carretaAbandonada = Cochero_getCarreta( this );
                Carreta_setCochero( carretaAbandonada, OBJECT_INVALID );
                Cochero_setCarreta( this, OBJECT_INVALID );

                //Sacar a los pasajeros de la instancia de carreta abandonada
                Carreta_descargarPasajeros( carretaAbandonada, Carreta_getEscaleraLoc( ultimaEstacionLoc ) );

                // programar que un nuevo cochero se apropie de la instancia de carreta abandonada.
                DelayCommand( 120.0, Carreta_apropiar( carretaAbandonada ) );
            }
        }   break;

        case Cochero_Estado_VIAJANDO: {
            object destinoWaypoint = GetLocalObject( this, Cochero_destinoWaypoint_FIELD );
            AssignCommand( this, SpeakString( "OHHH... *El cochero ordena a los caballos detenerse*... Pasajeros, hemos llegado a " + Cochero_getDestinoViaje( OBJECT_SELF ) ) );
            DelayCommand( 4.0f, Cochero_arrivarAEstacion(destinoWaypoint) ); // este retardo no tiene otro proposito mas que dar tiempo a leer el texto, ya que arribarAEstacion() los saca del area interior de la carreta.
            } break;

        default:
            PrintString( "TimerHandler: error 1 en carreta="+GetName( Cochero_getCarreta(this) )+", estado="+IntToString(Cochero_getEstado( this )) );
            break;

    }

//    SendMessageToPC( GetFirstPC(), "TimerHandler: end "+GetName( Cochero_getCarreta(OBJECT_SELF) ) );
}


// Inicializa al cochero OBJECT_SELF, que consiste en asociarlo a la 'carretaAsociada' y hacerlo partir a la estacion siguiente a la primera del recorrido.
// Se asume que 'carretaAsociada' no esta asociada a otro cochero
void Cochero_constructor( object carretaAsociada );
void Cochero_constructor( object carretaAsociada ) {
    object this = OBJECT_SELF;

    // Elimina un posible cochero previo asociado a esta carreta. Esto solo tiene efecto cuando el un DM crea un nuevo chochero y el anterior aun vive.
    DestroyObject( Carreta_getCochero( carretaAsociada ) );

    // Quitar el placeable y caballos de la carreta abandonada. Esto solo tiene efecto si hubo un cochero anterior y fue eliminado mientras la carreta descansaba en una estacion.
    Carreta_sacarCuerpoPlaceable( carretaAsociada );

    // Asocia el cochero con la carreta y viceversa
    Carreta_setCochero( carretaAsociada, this );
    SetLocalObject( this, Cochero_carretaRef_FIELD, carretaAsociada );

    // inicializa la memoria de quienes pagan
    struct Address memoriaPagaron;
    memoriaPagaron.nbh = OBJECT_SELF;
    memoriaPagaron.path = Cochero_memoriaPagaron_FIELD;
    VectorObj_constructor( memoriaPagaron );

    // Inicia el viaje de la primer estacion hacia la siguiente.
    Cochero_partirHaciaDestino( Carreta_getPrimerEstacion( carretaAsociada ) );
}

