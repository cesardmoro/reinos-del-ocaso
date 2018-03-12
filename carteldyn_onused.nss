#include "carteldyn_inc"

void main()
{
    object oPC = GetLastUsedBy();
    SetListening( OBJECT_SELF, TRUE );
    SetListenPattern( OBJECT_SELF, "**", 939 );

    SetCustomToken( CartelDinamico_token_VN, GetLocalString( OBJECT_SELF, CartelDinamico_contenido_VN ) );
    ActionStartConversation( oPC, CartelDinamico_conversacion_RN, TRUE, FALSE );
}
