/********************* Cochero - fachada ************************************
Cochero - include
Author: Inquisidor
Version: 0.1
Descripcion: fachada de la clase Cochero.
*************************************************************************/

////////////////// instance variables ////////////////////////////////

const string Cochero_memoriaPagaron_FIELD = "memoriaPagaron";
const string Cochero_carretaRef_FIELD = "carreta";
const string Cochero_ultimaEstacionLoc_FIELD = "ultimaEstacionLoc";  // recuerda la locacion de la ultima estacion donde se detuvo. Nota: Solo es valido si el cochero termino algun viaje arrivando a alguna estacion.
const string Cochero_destinoWaypoint_FIELD = "destinoWaypoint";
const string Cochero_destinoNombre_FIELD = "destinoNombre";
const string Cochero_presio_FIELD = "presio";
const string Cochero_fechaHoraArrivoDestino_FIELD = "fechaHoraArrivoDestino"; // Hora a la que este cochero arrivara a la proxima estacion (si esta andando), o la hora a la que arrivo a la estacion actual (si esta estacionado). Se actualiza cuando se parte de una estacion.
const string Cochero_fechaHoraProximaPartida_FIELD = "fechaHoraProximaPartida"; // Hora a la que este cochero partira a la proxima estacion (si esta estacionado), o la hora a la que partio desde la ultima estacion (si esta andando). Se actualiza cuando se arriva a una estacion.
const string Cochero_estado_FIELD = "estado";
    const int Cochero_Estado_DESCANSANDO = 1;
    const int Cochero_Estado_VIAJANDO = 2;
    const int Cochero_Estado_INACTIVO = 3;
    const int Cochero_Estado_DESPERTANDO = 4;


////////////////// instance operations ///////////////////////////////

object Cochero_getCarreta( object this );
object Cochero_getCarreta( object this ) {
    return GetLocalObject( this, Cochero_carretaRef_FIELD );
}


void Cochero_setCarreta( object this, object carreta );
void Cochero_setCarreta( object this, object carreta ) {
    SetLocalObject( this, Cochero_carretaRef_FIELD, carreta );
}


int Cochero_getPresioViaje( object this, object cliente );
int Cochero_getPresioViaje( object this, object cliente ) {
    return GetLocalInt( this, Cochero_presio_FIELD );// GetSkillRank( SKILL_APPRAISE, cliente ) ;
}


string Cochero_getDestinoViaje( object this );
string Cochero_getDestinoViaje( object this ) {
    return GetLocalString( this, Cochero_destinoNombre_FIELD );
}

// Da la hora a la que este cochero partira a la proxima estacion (si esta estacionado), o la hora a la que partio desde la ultima estacion (si esta andando). Se actualiza cuando se arriva a una estacion.
int Cochero_getFechaHoraProximaPartida( object this );
int Cochero_getFechaHoraProximaPartida( object this ) {
    return GetLocalInt( this, Cochero_fechaHoraProximaPartida_FIELD );
}


// Da la hora a la que este cochero arrivara a la proxima estacion (si esta andando), o la hora a la que arrivo a la estacion actual (si esta estacionado). Se actualiza cuando se parte de una estacion.
int Cochero_getFechaHoraArrivoDestino( object this );
int Cochero_getFechaHoraArrivoDestino( object this ) {
    return GetLocalInt( this, Cochero_fechaHoraArrivoDestino_FIELD );
}


// Da el estado del chochero. Son dos estados mutualmente excluyentes:
// Cochero_Estado_DESCANSANDO y Cochero_Estado_VIAJANDO.
int Cochero_getEstado( object this );
int Cochero_getEstado( object this ) {
    return GetLocalInt( this, Cochero_estado_FIELD );
}


// Da la locacion de la ultima estacion donde se detuvo.
// Nota: Solo es valido si el cochero termino algun viaje arrivando a alguna estacion.
location Cochero_getUltimaEstacion( object this );
location Cochero_getUltimaEstacion( object this ) {
    return GetLocalLocation( this, Cochero_ultimaEstacionLoc_FIELD );
}

