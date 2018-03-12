#include "Cochero"

void main()
    /* le quita al cliente tanto oro como el presio del viaje y hace memorizar al cochero
    que el cliente ya pago por este viaje. Notar que solo lo memoriza si no lleva
    casco. */
{
    TakeGoldFromCreature(
        Cochero_getPresioViaje( OBJECT_SELF, GetPCSpeaker() ),
        GetPCSpeaker(),
        TRUE
    );

    Cochero_memorizarRostro( OBJECT_SELF, GetPCSpeaker() );
}
