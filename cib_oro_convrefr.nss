#include "CIB_Oro"

int StartingConditional() {
    SetCustomToken( 7777, IntToString( CIB_Oro_getMonto( GetPCSpeaker() ) ) );
    return TRUE;
}
