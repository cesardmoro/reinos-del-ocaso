#include "RS_dmc_inc"

void main() {
    SendMessageToPC( GetPCSpeaker(), "Superficie por encuentro incrementada a "+IntToString( RS_DMC_setSPE( RS_DMC_getSPE() + 5 ) ) );
}
