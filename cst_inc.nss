/***************** clerigos que sirven en los templos **************************
Package: Cerigos que Sirven en los Templos - include
Author: Inquisidor
*******************************************************************************/
#include "Time_inc"
#include "sp_resu_inc"

const int CST_CUSTOM_TOKEN_BASE = 2000;
const string CST_DEAD_BODIES_ARRAY_PREFIX = "dbap#";
const string CST_DEAD_BODIES_ARRAY_SIZE = "dbas";


// ADVERTENCIA: si se cambia alguna de las siguientes constantes, por favor actualizar el diálogo "clerigo"
const int CST_MIN_TIME_BETWEEN_CURES = 720; // = 4*Time_MINUTES_IN_AN_HOUR
const int CST_MIN_TIME_BETWEEN_RESTORES = 2160; // = 12*Time_MINUTES_IN_AN_HOUR
const int CST_MIN_TIME_BETWEEN_RESURRECTS = 8640; // = 48*Time_MINUTES_IN_AN_HOUR

//////////////// Module variable prefixes //////////////////////////////////////

const string CST_LastCureDate_MVP = "cstLCureD";
const string CST_LastRestorationDate_MVP = "cstLRestoD";
const string CST_LastResurrectionDate_MVP = "cstLResuD";


// Arma un arreglo (se guarda en OBJECT_SELF) con los cadaveres de PJs que esten a menos de 20 metros de OBJECT_SELF.
void CST_makeDeadBodiesArray( object requester );
void CST_makeDeadBodiesArray( object requester ) {
    location resuZone = GetLocation( OBJECT_SELF );

    int index = 0;
    object creatureIterator = GetFirstObjectInShape( SHAPE_SPHERE, 20.0, resuZone, FALSE, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid(creatureIterator) ) {
        if( GetCurrentHitPoints( creatureIterator ) < -10 ) {
            SetCustomToken( CST_CUSTOM_TOKEN_BASE + index, GetName( creatureIterator ) );
            SetLocalObject( OBJECT_SELF, CST_DEAD_BODIES_ARRAY_PREFIX + IntToString(index), creatureIterator );
            index += 1;
        }
        creatureIterator = GetNextObjectInShape(SHAPE_SPHERE, 20.0, resuZone, FALSE, OBJECT_TYPE_CREATURE );
    }
    SetLocalInt( OBJECT_SELF, CST_DEAD_BODIES_ARRAY_SIZE, index );
}



// funcion privada usada solo por 'resurrect(...)'
void CST_rememberLastResurrectDate( object requester) {
    if( GetIsObjectValid( requester ) && GetLocalInt( OBJECT_SELF, ResurrectCreature_lastWasSuccessful_VN ) )
        SetLocalInt( GetModule(), CST_LastResurrectionDate_MVP + GetName(requester), Time_secondsSince1300() );
}

// Hace que OBJECT_SELF castee resurrección sobre el cadaver con índice 'optionIndex' del arreglo de cadaveres que se asume fue guardado en OBJECT_SELF previamente (ver 'CST_makeDeadBodiesArray(..)').
// Si el hechizo tiene éxito, se registra en el módulo la hora y fecha en que 'requester' uso este servicio.
void CST_resurrect( int optionIndex, object requester );
void CST_resurrect( int optionIndex, object requester ) {

    object target = GetLocalObject( OBJECT_SELF, CST_DEAD_BODIES_ARRAY_PREFIX + IntToString(optionIndex) );
    if( GetIsObjectValid( target ) ) {

        DeleteLocalInt( OBJECT_SELF, ResurrectCreature_lastWasSuccessful_VN );

        ClearAllActions();

        // si el NPC que realiza la resurreccion no es un henchman, realizar la resureccion inmediatamnete, ademas de hacerlo de forma normal, para evitar que la accion sea cancelada por la inteligencia artificial del NPC.
        if( GetMaster(OBJECT_SELF)==OBJECT_INVALID ) {
            ActionDoCommand( ActionCastSpellAtObject(
                SPELL_RAISE_DEAD
                , target
                , METAMAGIC_ANY
                , TRUE
                , 0
                , PROJECTILE_PATH_TYPE_DEFAULT
                , TRUE
            ) );
        }

        ActionDoCommand( ActionDoCommand( CST_rememberLastResurrectDate( requester ) ) ); // el doble ActionDoCommand() es necesario para que el procedimiento suceda despues de la acción de la linea anterior.

        ActionDoCommand( ActionCastSpellAtObject(
            SPELL_RAISE_DEAD
            , target
            , METAMAGIC_ANY
            , TRUE
        ) );

    }
}
