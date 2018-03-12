#include "Cochero"

int StartingConditional()
    /* Da TRUE si el cochero recuerda el rostro del pasajero, cosa que memoriza de cada uno que paga. */
{
    return Cochero_recordarRostro( OBJECT_SELF, GetPCSpeaker() );
}
