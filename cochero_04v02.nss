#include "Cochero"

int StartingConditional()
    /* da TRUE si el cliente tiene para pagar el presio del viaje */
{
    return GetGold( GetPCSpeaker() ) >= Cochero_getPresioViaje( OBJECT_SELF, GetPCSpeaker() );
}
