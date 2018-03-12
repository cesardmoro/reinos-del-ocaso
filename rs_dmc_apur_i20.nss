#include "RS_dmc_inc"

void main() {
    SendMessageToPC( GetPCSpeaker(), "Modificador aumento poder último refuerzo incrementado a "+IntToString( RS_DMC_setAPUR( RS_DMC_getAPUR() + 20 ) ) );
}
