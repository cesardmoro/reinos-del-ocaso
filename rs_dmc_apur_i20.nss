#include "RS_dmc_inc"

void main() {
    SendMessageToPC( GetPCSpeaker(), "Modificador aumento poder �ltimo refuerzo incrementado a "+IntToString( RS_DMC_setAPUR( RS_DMC_getAPUR() + 20 ) ) );
}
