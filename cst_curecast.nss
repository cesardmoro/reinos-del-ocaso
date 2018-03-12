#include "CST_inc"

const int OPTION_INDEX = 0;

void rememberLastCureDate(object requester) {
    if( GetIsObjectValid( requester ) )
        SetLocalInt( GetModule(), CST_LastCureDate_MVP + GetName(requester), Time_secondsSince1300() );
}

void main() {
    object requester = GetPCSpeaker();

    ClearAllActions();

    ActionDoCommand( ActionCastSpellAtObject(
        SPELL_CURE_CRITICAL_WOUNDS
        , requester
        , METAMAGIC_ANY
        , TRUE
    ) );

    ActionDoCommand( ActionDoCommand( rememberLastCureDate(requester) ) ); // el doble ActionDoCommand() es necesario para que el procedimiento suceda despues de la acción de la linea anterior.
}

