#include "CIB_Oro"

void main()
{
    object user = GetLastUsedBy();
    if( GetIsPC(user) ) {
        CIB_Oro_adquirir( OBJECT_SELF, user );
//        FloatingTextStringOnCreature( GetName(user)+" toma oro", user );
    }
}
