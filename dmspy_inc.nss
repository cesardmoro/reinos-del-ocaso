/******************************************************************************
08-12-08 - Script by Dragoncin
Varita para espiar PJs.

Permite:
- Escuchar todo lo que dice un PJ a distancia
*****************************************************************************/
#include "inc_Msg"
#include "Colors_inc"

////////////////////// CONFIGURACION ////////////////////////////////////////
const string DMSpy_ON_MESSAGE                = "Estas espiando a ";
const string DMSpy_OFF_MESSAGE               = "Ya NO estas espiando a ";

const string DMSpy_dmWand_RN                 = "varita_espia";

const int DMSpy_MAX_NUMBER_OF_DMS_CAN_SPY    = 10;

/////////////////////// METODOS /////////////////////////////////////////////

// Sets, gets, toggles if dm control over party talk is enforced
const string DMSpy_pcIsBeingSpyedOnBy_slot_VN = "pcisbeingspyed";

int DMSpy_getIsPCBeignSpyedOnBy( object oPC, object oDM );
int DMSpy_getIsPCBeignSpyedOnBy( object oPC, object oDM )
{
    int slot = 1;
    int is_being_spyed_by = FALSE;
    for ( slot = 1; slot<=DMSpy_MAX_NUMBER_OF_DMS_CAN_SPY; slot++ ) {
        if ( GetLocalObject(oPC, DMSpy_pcIsBeingSpyedOnBy_slot_VN+IntToString(slot)) == oDM ) {
            is_being_spyed_by = TRUE;
            break;
        }
    }
    return is_being_spyed_by;
}

void DMSpy_startSpyingOn( object oPC, object oDM );
void DMSpy_startSpyingOn( object oPC, object oDM )
{
    int slot = 1;
    for ( slot = 1; slot<=DMSpy_MAX_NUMBER_OF_DMS_CAN_SPY; slot++ ) {
        if ( !GetIsObjectValid( GetLocalObject(oPC, DMSpy_pcIsBeingSpyedOnBy_slot_VN+IntToString(slot)) ) ) {
            SetLocalObject( oPC, DMSpy_pcIsBeingSpyedOnBy_slot_VN+IntToString(slot), oDM );
            break;
        }
    }
    SendMessageToPC( oDM, DMSpy_ON_MESSAGE+GetName(oPC) );
}

void DMSpy_stopSpyingOn( object oPC, object oDM );
void DMSpy_stopSpyingOn( object oPC, object oDM )
{
    int slot = 1;
    for ( slot = 1; slot<=DMSpy_MAX_NUMBER_OF_DMS_CAN_SPY; slot++ ) {
        if ( GetLocalObject(oPC, DMSpy_pcIsBeingSpyedOnBy_slot_VN+IntToString(slot)) == oDM ) {
            DeleteLocalObject( oPC, DMSpy_pcIsBeingSpyedOnBy_slot_VN+IntToString(slot) );
            break;
        }
    }
    SendMessageToPC( oDM, DMSpy_OFF_MESSAGE+GetName(oPC) );
}

void DMSpy_toggleSpyingOn( object oPC, object oDM );
void DMSpy_toggleSpyingOn( object oPC, object oDM )
{
    if ( DMSpy_getIsPCBeignSpyedOnBy(oPC, oDM) ) {
        DMSpy_stopSpyingOn( oPC, oDM );
    } else {
        DMSpy_startSpyingOn( oPC, oDM );
    }
}


// Ejecuta el modo espia
struct ChatMessage DMSpy_onPlayerChat( struct ChatMessage message );
struct ChatMessage DMSpy_onPlayerChat( struct ChatMessage message )
{
    if ( message.volume == TALKVOLUME_TALK || message.volume == TALKVOLUME_WHISPER ) {
        string dm_message = (message.volume == TALKVOLUME_WHISPER) ? "*ss*"+message.content : message.content;
        dm_message = ColorString( GetName(message.speaker)+": ", COLOR_CYAN )+ColorString( message.content, COLOR_WHITE );
        int slot = 1;
        for ( slot = 1; slot<=DMSpy_MAX_NUMBER_OF_DMS_CAN_SPY; slot++ ) {
            if ( GetIsObjectValid( GetLocalObject(message.speaker, DMSpy_pcIsBeingSpyedOnBy_slot_VN+IntToString(slot)) ) ) {
                SendMessageToPC( GetLocalObject(message.speaker, DMSpy_pcIsBeingSpyedOnBy_slot_VN+IntToString(slot)), dm_message );
            }
        }
    }
    return message;
}

// Permite activar o desactivar el modo espia
void DMSpy_onWandActivate( object activator, object target );
void DMSpy_onWandActivate( object activator, object target )
{
    if ( GetIsDM(activator) && GetIsObjectValid(target) && GetIsPC(target) ) {
        DMSpy_toggleSpyingOn(target, activator);
    }
}
