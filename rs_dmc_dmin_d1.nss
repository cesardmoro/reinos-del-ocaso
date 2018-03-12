#include "RS_dmc_inc"

void main() {
    SendMessageToPC( GetPCSpeaker(), "distancia minima decrementada a "+IntToString( RS_DMC_setDMin( RS_DMC_getDMin() - 1 ) ) );
}
