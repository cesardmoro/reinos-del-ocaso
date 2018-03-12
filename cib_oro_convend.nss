#include "CIB_Oro"


void main() {
    if( CIB_Oro_getMonto( GetPCSpeaker() ) == 0 )
        CIB_Oro_cancelarMonto( GetPCSpeaker() );

}
