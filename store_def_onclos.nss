/////////////////////
// 07/04/07 Script By Inquisidor and Dragoncin
//
// Evento OnClosed estandar para merchants
//
// ADVERTENCIA: La clave formada con los primeros 16 caracteres del tag de una instancia de Store, debe ser única dentro del area donde este ubicada.
////////////////////////////

#include "Store_inc"
#include "Skills_sinergy"

void main() {
    object cliente = GetLastClosedBy();
    if( GetIsPC( cliente ) ) {
        Store_actualizarPrecioItemsPartidaCliente( cliente );
        IPS_Subject_onCloseStore( cliente );
        Skills_Sinergy_storeOnClose( cliente );
    }

    Store_actualizePersistence( OBJECT_SELF );
}

