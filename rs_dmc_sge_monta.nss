#include "RS_DMC_inc"
void main() {
    SendMessageToPC( GetPCSpeaker(), "SGE del area cambiado a "+RS_DMC_setSGE( "sgeMontanas" ) );
}

