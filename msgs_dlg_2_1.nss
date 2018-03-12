#include "Mensajeria_inc"

void main()
{
    object oPC = GetPCSpeaker();
    int nMatch = GetListenPatternNumber();
    string nombreRemitente = GetMatchedSubstring(0);

    if (Mensajeria_DEBUG) SendMessageToPC( oPC, "nombreRemitente= "+nombreRemitente );
    SetLocalString( oPC, Mensajeria_remitenteElegido_VN, nombreRemitente );
}
