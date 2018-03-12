/////////////////////
// Evento OnOpen estandar para merchants
// Author: Inquisidor
//
// ADVERTENCIA: La clave formada con los primeros 16 caracteres del tag de una instancia de Store, debe ser única dentro del area donde este ubicada.
////////////////////////////

#include "store_inc"

void main() {
    if( !GetLocalInt( OBJECT_SELF, Store_wasOpenedBefore_VN ) )
        Store_initialize( OBJECT_SELF );

    object cliente = GetLastOpenedBy();
    if( GetIsPC( cliente ) ) {
        Store_actualizarPrecioItemsArrivoCliente( cliente );
        IPS_Subject_onOpenStore( cliente );
    }
}

