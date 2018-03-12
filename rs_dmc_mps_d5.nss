#include "RS_dmc_inc"

void main() {
    SendMessageToPC( GetPCSpeaker(), "Modificador periodo decrementado a "+IntToString( RS_DMC_setMPS( RS_DMC_getMPS() - 5 ) ) );
}
