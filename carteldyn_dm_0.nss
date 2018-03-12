#include "carteldyn_inc"

void main()
{
    if (CartelDinamico_DEBUG)
        SendMessageToPC( GetPCSpeaker(), "isListening= "+IntToString(GetIsListening(OBJECT_SELF)) );
}
