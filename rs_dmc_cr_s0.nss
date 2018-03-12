#include "RS_dmc_inc"

void main() {
    SendMessageToPC( GetPCSpeaker(), "CR del area puesto en "+IntToString( RS_DMC_setCr( 0 ) ) );
}
