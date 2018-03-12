#include "Cochero"

const int customTokensBaseIndex = 3200;

int StartingConditional()
    /* Actualiza los custom tokens y condicionales del dialogo.
    Nunca se ve.*/
{
    int dineroCliente = GetGold( GetPCSpeaker() );
    int presioViaje = Cochero_getPresioViaje( OBJECT_SELF, GetPCSpeaker() );

    SetCustomToken( 0 + customTokensBaseIndex, IntToString( presioViaje ) );
    SetCustomToken( 1 + customTokensBaseIndex, Cochero_getDestinoViaje( OBJECT_SELF ) );
    SetCustomToken( 2 + customTokensBaseIndex, IntToString( dineroCliente < presioViaje ? dineroCliente : presioViaje - 1 ) );
    return FALSE;
}
