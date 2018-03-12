#include "RS_dmc_inc"

void main() {
    SendMessageToPC( GetPCSpeaker(), "Modificador cantidad refuerzos incrementado a "+IntToString( RS_DMC_setMCESR( RS_DMC_getMCESR() + 20 ) ) );
}
