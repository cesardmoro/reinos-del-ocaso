/******************************************************************************
08-12-08 - Script by Dragoncin
Control de volumen general del modulo

Permite:
- Hablar con susurros usando el shortcut *ss*
- Bloquear el party talk a todos menos a los seleccionados por la Varita de Control de Volumen
*****************************************************************************/

////////////////////// CONFIGURACION ////////////////////////////////////////
const string VolumeControl_WHISPER_SHORTCUT                 = "*SS*";
const string VolumeControl_DM_CANNOT_PTALK_MESSAGE          = " NO puede hablar por canal party";
const string VolumeControl_DM_CAN_PTALK_MESSAGE             = " puede hablar por canal party";
const string VolumeControl_PC_CANNOT_PTALK_MESSAGE          = "NO puedes hablar por canal party";
const string VolumeControl_PC_CAN_PTALK_MESSAGE             = "Puedes hablar por canal party";
const string VolumeControl_DMCTRL_NOT_ENFORCED_MESSAGE          = "Todos los personajes pueden usar el canal Party";
const string VolumeControl_DMCTRL_ENFORCED_MESSAGE      = "Los personajes NO pueden usar el canal Party salvo que un DM se los permita";

const string VolumeControl_dmWand_RN                        = "dmvolumectrl";


/////////////////////// METODOS /////////////////////////////////////////////
void VolumeControl_sendMessageToAllPlayers( string message );
void VolumeControl_sendMessageToAllPlayers( string message )
{
    object oPC = GetFirstPC();
    while ( GetIsObjectValid(oPC) )
    {
        SendMessageToPC( oPC, message );
        oPC = GetNextPC();
    }
}

// Sets, gets, toggles if dm control over party talk is enforced
const string VolumeControl_dmControlEnforced_VN = "dmvolumectrl";

int VolumeControl_getIsDMControlEnforced();
int VolumeControl_getIsDMControlEnforced()
{
    return GetLocalInt( GetModule(),VolumeControl_dmControlEnforced_VN );
}

void VolumeControl_setIsDMControlEnforced( int is_enforced );
void VolumeControl_setIsDMControlEnforced( int is_enforced )
{
    string message = ( is_enforced == TRUE ) ? VolumeControl_DMCTRL_ENFORCED_MESSAGE : VolumeControl_DMCTRL_NOT_ENFORCED_MESSAGE;
    SendMessageToAllDMs( message );
    VolumeControl_sendMessageToAllPlayers( message );
    SetLocalInt( GetModule(),VolumeControl_dmControlEnforced_VN, is_enforced );
}

void VolumeControl_toggleDMControlEnforced();
void VolumeControl_toggleDMControlEnforced()
{
    if ( VolumeControl_getIsDMControlEnforced() == TRUE ) {
        VolumeControl_setIsDMControlEnforced( FALSE );
    } else {
        VolumeControl_setIsDMControlEnforced( TRUE );
    }
}


// Sets, gets, toggles if player can party talk
const string VolumeControl_playerCanPartyTalk_VN = "pccanptalk";

int VolumeControl_getPlayerCanPartyTalk( object oPC );
int VolumeControl_getPlayerCanPartyTalk( object oPC )
{
    return GetLocalInt( GetModule(),VolumeControl_playerCanPartyTalk_VN );
}

void VolumeControl_setPlayerCanPartyTalk( object oPC, int can_ptalk );
void VolumeControl_setPlayerCanPartyTalk( object oPC, int can_ptalk )
{
    string dm_message = ( can_ptalk == TRUE ) ? GetName(oPC)+VolumeControl_DM_CAN_PTALK_MESSAGE : GetName(oPC)+VolumeControl_DM_CANNOT_PTALK_MESSAGE;
    string pc_message = ( can_ptalk == TRUE ) ? VolumeControl_PC_CAN_PTALK_MESSAGE : VolumeControl_PC_CANNOT_PTALK_MESSAGE;
    SendMessageToAllDMs( dm_message );
    VolumeControl_sendMessageToAllPlayers( pc_message );
    SetLocalInt( GetModule(),VolumeControl_playerCanPartyTalk_VN, can_ptalk );
}

void VolumeControl_togglePlayerCanPartyTalk( object oPC );
void VolumeControl_togglePlayerCanPartyTalk( object oPC )
{
    if ( VolumeControl_getPlayerCanPartyTalk( oPC ) == TRUE ) {
        VolumeControl_setPlayerCanPartyTalk( oPC, FALSE );
    } else {
        VolumeControl_setPlayerCanPartyTalk( oPC, TRUE );
    }
}

//Permite:
//- Hablar con susurros usando el shortcut *ss*
//- Cambiar el volumen a conversacion comun en caso de que el dm no permita hablar por party talk
struct ChatMessage VolumeControl_execute( struct ChatMessage message );
struct ChatMessage VolumeControl_execute( struct ChatMessage message )
{
    if ( message.volume == TALKVOLUME_TALK ) {

        if ( GetStringLeft(GetStringUpperCase(message.content), GetStringLength(VolumeControl_WHISPER_SHORTCUT)) == VolumeControl_WHISPER_SHORTCUT ) {
             message.volume = TALKVOLUME_WHISPER;
        }

    } else if ( message.volume == TALKVOLUME_PARTY ) {
        if ( VolumeControl_getIsDMControlEnforced() == TRUE && VolumeControl_getPlayerCanPartyTalk(message.speaker) == FALSE ) {
             message.volume = TALKVOLUME_TALK;
        }
    }
    return message;
}

// Permite activar o desactivar el control de party talk
void VolumeControl_onWandActivate( object activator, object target );
void VolumeControl_onWandActivate( object activator, object target )
{
    if ( GetIsDM(activator) ) {
        if ( GetIsObjectValid(target) && GetIsPC(target) ) {
            VolumeControl_togglePlayerCanPartyTalk(target);
        } else {
            VolumeControl_toggleDMControlEnforced();
        }
    }
}
