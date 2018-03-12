/******************** class Carreta - implementacion parte 2 *******************
Carreta - include
Author: Inquisidor
Version: 0.1
Descripcion: define una carreta. Sus responsabilidades son: conocer las
estaciones que recorre, presio y duracion de los viajes y descansos.
La implementacion se separó en dos partes para evitar limitaciones del compilador
*******************************************************************************/

#include "Cochero"

//Debe ser llamada desde el handler atado al evento onAreaEnter correspondiente al área interior de la carreta cuando entra un jugador, sea PJ o DM.
void Carreta_onPcEntersArea();
void Carreta_onPcEntersArea()  {
    object carreta = OBJECT_SELF;
    object cochero = Carreta_getCochero( carreta );
    if( GetLocalInt( cochero, Cochero_estado_FIELD ) == Cochero_Estado_INACTIVO ) {
        SetLocalInt( cochero, Cochero_estado_FIELD, Cochero_Estado_DESPERTANDO ); // esta linea esta para evitar que se llame dos veces a 'Cochero_arrivarAEstacion(..)', cuando este handler es se pone mas de una vez en la cola de acciones antes de que se ejecute alguno (sucede si se loguean dos PJs al mismo tiempo y ambos estan dentro de la misma carreta inactiva).
        SetLocalInt( OBJECT_SELF, Cochero_fechaHoraArrivoDestino_FIELD, DateTime_getActual() + 30  );
        object estacionWaypoint = GetLocalObject( cochero, Cochero_destinoWaypoint_FIELD );
        AssignCommand( cochero, DelayCommand( 3.0, Cochero_arrivarAEstacion( estacionWaypoint ) ) );
    }
}

