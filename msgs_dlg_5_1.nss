#include "Mensajeria_inc"

void main()
{
    object oPC = GetPCSpeaker();

    int idioma = GetLocalInt( oPC, Mensajeria_idiomaElegido_VN );
    string mensaje = GetLocalString( oPC, Mensajeria_mensajeElegido_VN );
    string destinatario = GetLocalString( oPC, Mensajeria_destinataElegido_VN );
    string remitente = GetLocalString( oPC, Mensajeria_remitenteElegido_VN );
    object papel = GetLocalObject( oPC, Mensajeria_papelElegido_VN );

    EscribirCarta( papel, oPC, destinatario, remitente, mensaje, idioma );
}
