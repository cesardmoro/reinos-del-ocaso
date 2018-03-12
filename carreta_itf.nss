/**************************** class Carreta - fachada **************************
Carreta - include
Author: Inquisidor
Version: 0.1
Descripcion: define una carreta. Sus responsabilidades son: conocer las
estaciones que recorre, presio y duracion de los viajes y descansos.
*******************************************************************************/
#include "Location_Tools"

////////////////// atributos de la carreta ///////////////////////////////
const string Carreta_cocheroWaypointTag_LN = "cocheroWaypointTag"; // indica el sitio donde se para el cochero al entrar a la carreta
const string Carreta_pasajeroWaypointTag_LN = "pasajeroWaypointTag"; // indica el sitio dentro de la carreta donde aparecen los pasajeros al entrar
const string Carreta_caidaWayPointTag_LN = "caidaWaypointTag";  // indica el sitio donde apareceran los pasajeros si salta o caen de la carreta cuando esta viajando
const string Carreta_vehiculoResRef_LN = "vehiculoResRef";
const string Carreta_cocheroResRef_LN = "cocheroResRef";
const string Carreta_caballoResRef_LN = "caballoResRef";

const string Carreta_PrimerEstacionRef_LN = "primerEstacionRef"; // tag del area donde esta la primer estacion.

// nombre de esta estacion que vera el jugador
const string Station_name_FIELD = ".name";
// sitio de esta estacion dentro del area. Debe haber lugar para dos caballos delante
const string Station_waypointTag_FIELD = ".waypointTag";
// tiempo de descanso en esta estacion
const string Station_restTime_FIELD = ".restTime";
// presio del viaje de esta estacion hacia la siguiente
const string Station_nextTripPrise_FIELD = ".nextTripPrise";
// duracion del viaje de esta estacion hacia la siguiente
const string Station_nextTripDuration_FIELD = ".nextTripDuration";
// referencia a la instancia de 'Station' correspondiente a la siguiente estacion. Las referencias a estaciones
const string Station_nextTripDestinationRef_FIELD = ".nextTripDestinationRef";


////////////////////// operaciones de clase ////////////////////////////////

// Da la location de la escalera de una carreta, dada la location de la estacion donde se detiene.
location Carreta_getEscaleraLoc( location carretaLoc );
location Carreta_getEscaleraLoc( location carretaLoc ) {
    return Location_createRelative( carretaLoc, -5.0, 0.0, -180.0 );
}


///////////////////// instance variables ///////////////////////////////////

const string Carreta_estaInicializada_FIELD = "estaInic"; // indica si esta carreta ya fue inicializada
const string Carreta_cochero_FIELD = "cochero"; // cochero asociado a esta carreta
const string Carreta_vehiculo_FIELD = "vehiculo";                   // recuerda el placeable del vehículo puesto en la última estación que detuvo esta carreta. Valido cuando la carreta esta detenida en una estacion.
const string Carreta_caballoIzquierdo_FIELD = "cabIzq";   // recuerda el caballo izquierdo puesto en la última estación que detuvo esta carreta. Valido cuando la carreta esta detenida en una estacion.
const string Carreta_caballoDerecho_FIELD = "cabDer";       // recuerda el caballo derecho puesto en la última estación que detuvo esta carreta. Valido cuando la carreta esta detenida en una estacion.

const string Campana_carreta_FIELD = "carreta"; // carreta asociada a esta campana
const string Campana_estacionWaypoint_FIELD = "estWp"; // waypoint correspondiente a la estación donde está esta campana

///////////////////// operaciones de instancia ///////////////////////////////

// Da el cochero que conduce a esta carreta
object Carreta_getCochero( object this );
object Carreta_getCochero( object this ) {
    return GetLocalObject( this, Carreta_cochero_FIELD );
}


// Asocia el cochero dado a esta carreta.
void Carreta_setCochero( object this, object cochero );
void Carreta_setCochero( object this, object cochero ) {
    SetLocalObject( this, Carreta_cochero_FIELD, cochero );
}


// Da el waypoint al que salta el cochero al entrar al area de esta carreta
object Carreta_getCocheroWaypoint( object this );
object Carreta_getCocheroWaypoint( object this ) {
    return GetWaypointByTag( GetLocalString( this, Carreta_cocheroWaypointTag_LN ) );
}


// Da el waypoint donde caen los pasajeros si saltan o la carreta choca.
object Carreta_getCaidaWaypoint( object this );
object Carreta_getCaidaWaypoint( object this ) {
    object caidaWaypoint = GetWaypointByTag( GetLocalString( this, Carreta_caidaWayPointTag_LN ) );
    if( caidaWaypoint == OBJECT_INVALID )
        PrintString( "Carreta_getCaidaWaypoint: error 1 - "+GetName( this ) );
    return caidaWaypoint;
}

struct Carreta_InfoSiguienteViaje {
    int presio; // presio del viaje a la estacion destino (la siguiente)
    int tiempoDescanso; // tiempo de descanso en la estacion actual antes de partir
    int duracionViaje; // duracion del viaje de la estacion actual hacia la destino (la siguiente)
    string destinoNombre; // nombre de la estacion destino (la siguiente)
    object destinoWaypoint; // waypoint donde aparecera la carreta y el cochero al terminar el viaje al destino (siguiente estacion)
};


// Da informacion acerca del viaje a la siguiente estacion de esta carreta.
struct Carreta_InfoSiguienteViaje Carreta_getInfoSiguienteViaje( object this, object estacion );
struct Carreta_InfoSiguienteViaje Carreta_getInfoSiguienteViaje( object this, object estacion ) {
    string error;
    string estacionRef = GetTag( estacion );
//    SendMessageToPC( GetFirstPC(), "Carreta_getInfoSiguienteViaje: estacionRef ="+estacionRef );
    struct Carreta_InfoSiguienteViaje info;
    info.presio = GetLocalInt( this, estacionRef + Station_nextTripPrise_FIELD );
//    SendMessageToPC( GetFirstPC(), "Carreta_getInfoSiguienteViaje: presio ="+IntToString( info.presio ) );
    info.tiempoDescanso = GetLocalInt( this, estacionRef + Station_restTime_FIELD );
//    SendMessageToPC( GetFirstPC(), "Carreta_getInfoSiguienteViaje: tiempoDescanso ="+IntToString( info.tiempoDescanso ) );
    info.duracionViaje = GetLocalInt( this, estacionRef + Station_nextTripDuration_FIELD );
//    SendMessageToPC( GetFirstPC(), "Carreta_getInfoSiguienteViaje: duracionViaje ="+IntToString( info.duracionViaje ) );
    string destinoRef = GetLocalString( this, estacionRef + Station_nextTripDestinationRef_FIELD );
//    SendMessageToPC( GetFirstPC(), "Carreta_getInfoSiguienteViaje: destinoRef ="+destinoRef );
    if( info.presio != 0 && info.duracionViaje != 0 && destinoRef != "" ) {
        info.destinoNombre = GetLocalString( this, destinoRef + Station_name_FIELD );
        info.destinoWaypoint = GetWaypointByTag( GetLocalString( this, destinoRef + Station_waypointTag_FIELD ) );
        if( info.destinoNombre != "" && info.destinoWaypoint != OBJECT_INVALID )
            return info;
    // de aqui para abajo es manejo de errores
         else
            error = "Carreta_getInfoSiguienteViaje: los datos de la estacion destino " + destinoRef + " estan incompletos.";
    }
    else
        error = "Carreta_getInfoSiguienteViaje: los datos de la estacion actual " + estacionRef + " estan incompletos.";
    PrintString( error );
    info.destinoNombre = error;
    info.destinoWaypoint = OBJECT_INVALID;
    return info;
}


// Hace aparecer esta carreta y sus caballos en la estacion dada (sucede cuando arriba a la estacion).
void Carreta_ponerCuerpoPlaceable( object this, location estacionLoc );
void Carreta_ponerCuerpoPlaceable( object this, location estacionLoc ) {
    location carretaLoc = Location_createRelative( estacionLoc, 0.0, 0.0, 180.0f ); // el 180 se debe a que el placeable de la carreta esta girado 180 grados
    location caballoIzqLoc = Location_createRelative( estacionLoc, 6.0f,  1.0f, 0.0 );
    location caballoDerLoc = Location_createRelative( estacionLoc, 6.0f, -1.0f, 0.0 );

    object vehiculo = CreateObject( OBJECT_TYPE_PLACEABLE, GetLocalString( this, Carreta_vehiculoResRef_LN ), carretaLoc );
    SetLocalObject( this, Carreta_vehiculo_FIELD, vehiculo );
    object caballoIzquierdo = CreateObject( OBJECT_TYPE_CREATURE, GetLocalString( this, Carreta_caballoResRef_LN ), caballoIzqLoc );
    SetLocalObject( this, Carreta_caballoIzquierdo_FIELD, caballoIzquierdo );
    object caballoDerecho = CreateObject( OBJECT_TYPE_CREATURE, GetLocalString( this, Carreta_caballoResRef_LN ), caballoDerLoc );
    SetLocalObject( this, Carreta_caballoDerecho_FIELD, caballoDerecho );

//    CreateObject( OBJECT_TYPE_PLACEABLE, "nw_plc_piratex", caballoIzqLoc );
//    CreateObject( OBJECT_TYPE_PLACEABLE, "nw_plc_piratex", caballoDerLoc );
}


// Hace desaparecer esta carreta junto con sus caballos (sucede cuando la carreta parte).
void Carreta_sacarCuerpoPlaceable( object this, float delay = 0.0f );
void Carreta_sacarCuerpoPlaceable( object this, float delay = 0.0f ) {
    object toDestroy = GetLocalObject( this, Carreta_vehiculo_FIELD );
    DeleteLocalObject( this, Carreta_vehiculo_FIELD );
    DestroyObject( toDestroy, delay );

    toDestroy = GetLocalObject( this, Carreta_caballoIzquierdo_FIELD );
    DeleteLocalObject( this, Carreta_caballoIzquierdo_FIELD );
    DestroyObject( toDestroy, delay );

    toDestroy = GetLocalObject( this, Carreta_caballoDerecho_FIELD );
    DeleteLocalObject( this, Carreta_caballoDerecho_FIELD );
    DestroyObject( toDestroy, delay );
}


// Da una referencia al primer pasajero dentro de esta carreta.
object Carreta_getFirstPasajero( object this );
object Carreta_getFirstPasajero( object this ) {
    object iterator = GetFirstObjectInArea( this );
    while( iterator != OBJECT_INVALID && !GetIsPC( iterator ) ) {
        iterator = GetNextObjectInArea( this );
    }
    return iterator;
}


// Da una referencia al siguiente pasajero dentro de esta carreta.
object Carreta_getNextPasajero( object this );
object Carreta_getNextPasajero( object this ) {
    object iterator = GetNextObjectInArea( this );
    while( iterator != OBJECT_INVALID && !GetIsPC( iterator ) ) {
        iterator = GetNextObjectInArea( this );
    }
    return iterator;
}


// Traslada todos los pasajeros del area interior de esta carreta, al sitio especificado.
void Carreta_descargarPasajeros( object this, location sitio );
void Carreta_descargarPasajeros( object this, location sitio ) {
    object pasajero = Carreta_getFirstPasajero( this );
    while( pasajero != OBJECT_INVALID ) {
        AssignCommand( pasajero, ClearAllActions(FALSE) );
        AssignCommand( pasajero, JumpToLocation( sitio ) );
        pasajero = Carreta_getNextPasajero( this );
    }
}


// Crea un nuevo cochero para esta carreta.
// Esta funcion se ejecuta un tiempo despues de morir o perderse el cochero de esta carreta.
void Carreta_apropiar( object this );
void Carreta_apropiar( object this ) {
//    SendMessageToPC( GetFirstPC(), "Carreta_apropiar: begin - "+GetName(OBJECT_SELF) );

    // si esta carrreta aun no tiene cochero (un DM pudo haber puesto uno), entonces crear uno dentro de la carreta
    if( !GetIsObjectValid( Carreta_getCochero( this ) ) ) {
//        SendMessageToPC( GetFirstPC(), "Carreta_apropiar: sin cochero - "+GetName(OBJECT_SELF) );

        string cocheroResRef = GetLocalString( this, Carreta_cocheroResRef_LN );
        if( cocheroResRef != "" ) {
            object waypoint = Carreta_getCocheroWaypoint( this );
            if( waypoint != OBJECT_INVALID ) {

                // Al ser creado el cochero dentro de la carreta, el on spawn handler se encargara de inicializar todo para que este nuevo cochero sea su conductor.
                object cochero = CreateObject(
                    OBJECT_TYPE_CREATURE,
                    GetLocalString( this, Carreta_cocheroResRef_LN),
                    GetLocation( waypoint )
                );

        // de aqui para abajo es log de errores

                if( cochero == OBJECT_INVALID )
                    PrintString( "Carreta_apropiar: Error 3" );
             } else PrintString( "Carreta_apropiar: Error 2" );
        } else PrintString( "Carreta_apropiar: Error 1" );
    }

}


// Da el area correspondiente a la primer estacion del circuito de esta carreta.
object Carreta_getPrimerEstacion( object this );
object Carreta_getPrimerEstacion( object this ) {
    string primerEstacionRef = GetLocalString( this, Carreta_PrimerEstacionRef_LN );
    object primerEstacion = GetObjectByTag( primerEstacionRef );
    if( primerEstacion != OBJECT_INVALID )
        return primerEstacion;
    else
        PrintString( "Carreta_getPrimerEstacion: error 1 - "+GetName(this) );
    return OBJECT_INVALID;
}


