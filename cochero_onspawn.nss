/************************ Cochero on spawn handler ****************************
Package: Sistema de tranporte por carreta - cochero - on spawn handler
Autor: Inquisidor
Version: 0.1
*******************************************************************************/
#include "Cochero"

void main() {
    ExecuteScript( "x2_def_spawn", OBJECT_SELF );
//    SendMessageToPC( GetFirstPC(), "self = "+GetName( OBJECT_SELF ) );
    object carreta = GetArea( OBJECT_SELF );

    // Si el area donde fue creado (por un DM), o puesto con el toolset, es el
    // interior de una carreta; entonces inicializar a este cochero asociandolo a
    // la carreta correspondiente al area.
    if( Carreta_esValida( carreta ) ) {
//        DelayCommand( 5.0, Cochero_constructor( carreta ) ); // como el onSpawn se ejecuta antes que el cochero
        Carreta_inicializar( carreta );
        Cochero_constructor( carreta );
    }

}
