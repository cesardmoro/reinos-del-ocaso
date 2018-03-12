/*******************************************************************************
Containers - RW_Shortcut - polymorphism support
Author: Inquisidor (Guido Gustavo Pollitzer)
Version: 0.1
Descripcion: Soporte de polimorfismo de la clase RW_Shortcut. RW_Shortcut implementa RW_RandomWay
y no adquiere ninguna operacion polimorfica.
*******************************************************************************/
#include "RW_Shortcut"


void main() {
    // desempaquetado de 'this'
    struct Address this;
    this.nbh = OBJECT_SELF;
    this.path = GetLocalString( OBJECT_SELF, Polymorphism_THIS_REF );
//    SendMessageToPC( GetFirstPC(), "Ctnr_vectorObj0: this.path=" + this.path );

    // demultiplexado de la operacion (multiplexada para reducir la cantidad de scripts y el mapeo de nombre de funcion a nombre de script )
    int operationId = GetLocalInt( OBJECT_SELF, Polymorphism_OPERATION_ID );
//    SendMessageToPC( GetFirstPC(), "Ctnr_vectorObj0: operationId=" + IntToString( operationId ) );
    switch( operationId ) {

        case Instance_destructor_OPERATION_ID: // heredada de Instance
            // desempaquetado de los parametros:
            // llamado al metodo
            RW_Shortcut_destructor_UMC( this );
            // empaquetado del resultado:
            break;


        case Instance_toText_OPERATION_ID: {// heredada de Instance
            // desempaquetado de los parametros:

            // llamado al metodo
            string toText_result = RW_Shortcut_toText_UMC( this );

            // empaquetado del resultado:
            SetLocalString( OBJECT_SELF, Polymorphism_RESULT_1_REF, toText_result );
            } break;


        case Instance_isEqual_OPERATION_ID: { // heredada de Instance
            // desempaquetado de los parametros: 'other'
            struct Address other;
            other.nbh = GetLocalObject( OBJECT_SELF, Polymorphism_PARAMETER_1_REF );
            other.path = GetLocalString( OBJECT_SELF, Polymorphism_PARAMETER_2_REF );

            // llamado al metodo
            int isEqual_result = RW_Shortcut_isEqual_UMC( this, other );

            // empaquetado del resultado: int
            SetLocalInt( OBJECT_SELF, Polymorphism_RESULT_1_REF, isEqual_result );
            } break;


        default:
            PrintString( "Ctnr_RW_Shortcut0: invalid operation identifier: " + IntToString( operationId ) );
        break;
    }
}
