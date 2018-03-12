#include "carteldyn_inc"

void main()
{
    object oPC = GetPCSpeaker();
    int nMatch = GetListenPatternNumber();
    string contenidoCartel = GetMatchedSubstring(0);

    if (CartelDinamico_DEBUG) SendMessageToPC( oPC, "contenidoCartel= "+contenidoCartel );
    SetLocalString( OBJECT_SELF, CartelDinamico_contenido_VN, contenidoCartel );
}
