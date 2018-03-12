#include "RS_dmc_inc"

void main() {
    SendMessageToPC( GetPCSpeaker(), "CR del area decrementado a "+IntToString( RS_DMC_setCr( RS_DMC_getCr() - 5 ) ) );
}
