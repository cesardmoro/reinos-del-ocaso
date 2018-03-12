#include "Mensajeria_inc"

void main()
{
    object oPC = GetPCSpeaker();
    int nMatch = GetListenPatternNumber();
    string nombreDestinatario = GetMatchedSubstring(0);

    if (Mensajeria_DEBUG) SendMessageToPC( oPC, "nombreDestinatario= "+nombreDestinatario );
    SetLocalString( oPC, Mensajeria_destinataElegido_VN, nombreDestinatario );
}
