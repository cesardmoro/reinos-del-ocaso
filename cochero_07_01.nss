#include "Cochero_itf"
#include "Carreta"

void main()
    /* Hace que el cliente suba a la carreta */
{
    // subirlo a la carreta
    object carreta = Cochero_getCarreta( OBJECT_SELF );
    Carreta_cargarPasajero( carreta, GetPCSpeaker() );
}
