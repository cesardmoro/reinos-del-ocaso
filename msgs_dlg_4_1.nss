#include "Mensajeria_inc"

void main()
{
    object oPC = GetPCSpeaker();
    int nMatch = GetListenPatternNumber();
    string mensajeNuevo = GetMatchedSubstring(0);

    if (Mensajeria_DEBUG) SendMessageToPC( oPC, "mensaje= "+mensajeNuevo );
    string mensajeActual = GetLocalString( oPC, Mensajeria_mensajeElegido_VN );
    SetLocalString( oPC, Mensajeria_mensajeElegido_VN, mensajeActual+"\n\n"+mensajeNuevo );
}
