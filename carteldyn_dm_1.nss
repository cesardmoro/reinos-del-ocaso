#include "carteldyn_inc"

void main()
{
    object oPC = GetPCSpeaker();
    int nMatch = GetListenPatternNumber();
    string nombreCartel = GetMatchedSubstring(0);

    if (CartelDinamico_DEBUG) SendMessageToPC( oPC, "nombreCartel= "+nombreCartel );
    SetName( OBJECT_SELF, nombreCartel );
}
