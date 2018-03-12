/****************** Varita nombradora de NPCs **********************************
Author: Inquisidor
*******************************************************************************/
#include "DM_inc"

const string VNNPC_wasListening = "VNNPCwl";
const int VNNPC_patternNumber = 542;
const string VNNPC_isWaitingNewName = "VNNPCisnw";


// Debe ser llamado desde el onActivateItem handler para que la varita de cambio
// de nombre funcione.
void VNNPC_onActivateItem();
void VNNPC_onActivateItem() {
    object target = GetItemActivatedTarget();
    if(
        GetIsDM(GetItemActivator())
        && target != OBJECT_INVALID
        && !GetIsPC( target )
    ) {
        SendMessageToPC( GetItemActivator(), GetName(target)+" esta esperando su nuevo nombre. Escribir 'nombre=<nombre elegido>' para dar un nombre a mano, o 'nombre=azar' para generaro al azar." );
        // recordar si estaba escuchando antes
        SetLocalInt( target, VNNPC_wasListening, GetIsListening( target ) );
        SetLocalInt( target, VNNPC_isWaitingNewName, TRUE );

        // hacer que escuche fraces que empiecen con "nombre="
        SetListening( target, TRUE );
        SetListenPattern( target, "nombre=**", VNNPC_patternNumber );
    }
}


// Genera un nombre apropiado para la criatura 'target'.
string VNNPC_generateName( object target );
string VNNPC_generateName( object target ) {
    string newName;

    switch( GetRacialType( OBJECT_SELF ) ) {

    case RACIAL_TYPE_ANIMAL:
        newName = RandomName( NAME_ANIMAL );

    case RACIAL_TYPE_DWARF:
        if( GetGender( target ) == GENDER_MALE )
            newName = RandomName( NAME_FIRST_DWARF_MALE ) + " " + RandomName( NAME_LAST_DWARF );
        else
            newName = RandomName( NAME_FIRST_DWARF_FEMALE ) + " " + RandomName( NAME_LAST_DWARF );
        break;

    case RACIAL_TYPE_ELF:
        if( GetGender( target ) == GENDER_MALE )
            newName = RandomName( NAME_FIRST_ELF_MALE ) + " " + RandomName( NAME_LAST_ELF );
        else
            newName = RandomName( NAME_FIRST_ELF_FEMALE ) + " " + RandomName( NAME_LAST_ELF );
        break;

    case RACIAL_TYPE_GNOME:
        if( GetGender( target ) == GENDER_MALE )
            newName = RandomName( NAME_FIRST_GNOME_MALE ) + " " + RandomName( NAME_LAST_GNOME );
        else
            newName = RandomName( NAME_FIRST_GNOME_FEMALE ) + " " + RandomName( NAME_LAST_GNOME );
        break;

    case RACIAL_TYPE_HALFELF:
        if( GetGender( target ) == GENDER_MALE )
            newName = RandomName( NAME_FIRST_HALFELF_MALE ) + " " + RandomName( NAME_LAST_HALFELF );
        else
            newName = RandomName( NAME_FIRST_HALFELF_FEMALE ) + " " + RandomName( NAME_LAST_HALFELF );
        break;

    case RACIAL_TYPE_HALFLING:
        if( GetGender( target ) == GENDER_MALE )
            newName = RandomName( NAME_FIRST_HALFLING_MALE ) + " " + RandomName( NAME_LAST_HALFLING );
        else
            newName = RandomName( NAME_FIRST_HALFLING_FEMALE ) + " " + RandomName( NAME_LAST_HALFLING );
        break;

    case RACIAL_TYPE_HALFORC:
        if( GetGender( target ) == GENDER_MALE )
            newName = RandomName( NAME_FIRST_HALFORC_MALE ) + " " + RandomName( NAME_LAST_HALFORC );
        else
            newName = RandomName( NAME_FIRST_HALFORC_FEMALE ) + " " + RandomName( NAME_LAST_HALFORC );
        break;

    case RACIAL_TYPE_HUMAN:
        if( GetGender( target ) == GENDER_MALE )
            newName = RandomName( NAME_FIRST_HUMAN_MALE ) + " " + RandomName( NAME_LAST_HUMAN );
        else
            newName = RandomName( NAME_FIRST_HUMAN_FEMALE ) + " " + RandomName( NAME_LAST_HUMAN );
        break;

    default:
        if( GetGender( target ) == GENDER_MALE )
            newName = RandomName( NAME_FIRST_GENERIC_MALE );
        else
            newName = RandomName( NAME_FIRST_GNOME_FEMALE );
        break;
    }
    return newName;
}

// Debe ser llamado desde el onConversation handler de los NPCs que se pretenda
// pueda cambiarse el nombre, para que la varita de cambio de nombre funcione.
// Devuelve TRUE si el nombre fue modificado, FALSE en caso contrario.
// Preferentemente llamarla al principio y saltear el resto del handler si devuelve TRUE.
//
int VNNPC_onConversation();
int VNNPC_onConversation() {
    object speaker = GetLastSpeaker();
    int patternNumber = GetListenPatternNumber();
    //SendMessageToPC(speaker, "VNNPC_onConversation: pattern="+IntToString(patternNumber)+", isWaiting="+IntToString(GetLocalInt( OBJECT_SELF, VNNPC_isWaitingNewName )));
    if(
        GetIsDM( speaker ) &&
        GetLocalInt( OBJECT_SELF, VNNPC_isWaitingNewName )
    ) {
        string newName;
        if( patternNumber == VNNPC_patternNumber ) {
            newName = GetMatchedSubstring( 1 );
        } else if( patternNumber == 0 ) {
            newName = GetMatchedSubstring( 0 );
            if( GetStringLeft( newName, 7 ) == "nombre=" ) {
                newName = GetStringRight( newName, GetStringLength(newName)-7 );
            } else
                return FALSE;
        }
        if( newName == "azar" )
            newName = VNNPC_generateName( OBJECT_SELF );
        SetName( OBJECT_SELF, newName );
        SetListening( OBJECT_SELF, GetLocalInt( OBJECT_SELF, VNNPC_wasListening ) );
        DeleteLocalInt( OBJECT_SELF, VNNPC_wasListening );
        DeleteLocalInt( OBJECT_SELF, VNNPC_isWaitingNewName );
        SendMessageToPC( GetLastSpeaker(), "Nombre modificado exitosamente a: ["+newName+"]" );
        return TRUE;
    }
    return FALSE;
}
