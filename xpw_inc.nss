#include "Experience_inc"
#include "RTG_Itf"
#include "SPC_inc"
#include "DM_inc"

///////////////////////////// constatns ////////////////////////////////////////

const string XPW_conversation_RN = "xpw_conversation";
const string XPW_item_RN = "xpw_item";
const string XPW_item_TAG = "XPW_item";


//////////////////////////// wand variable names ///////////////////////////////

const string XPW_targetObject_VN = "XPWto";


///////////////////////////////// operations ///////////////////////////////////

void XPW_onActivated( object wand, object activator, object targetObject, location targetLocation );
void XPW_onActivated( object wand, object activator, object targetObject, location targetLocation ) {
    if( GetIsPC( targetObject ) && !GetIsDM( targetObject ) && activator != targetObject && GetIsAllowedDM(activator) ) {
        SetLocalObject( activator, XPW_targetObject_VN, targetObject );
        AssignCommand( activator, ActionStartConversation( activator, XPW_conversation_RN, TRUE, FALSE ) );
    }
}


void XPW_darPremioXpYOro( object pcSpeaker, int xpADar );
void XPW_darPremioXpYOro( object pcSpeaker, int xpADar ) {
    object targetObject = GetLocalObject( pcSpeaker, XPW_targetObject_VN );
    Experience_dar( targetObject, xpADar );
    int nivelPj = GetHitDice(targetObject) + GetLocalInt( targetObject, RDO_modificadorNivelSubraza_PN );
    int oroADar = FloatToInt( xpADar * nivelPj * RTG_TOKEN_VALUE_PER_CR/SPC_PREMIO_XP_NOMINAL );
    GiveGoldToCreature( targetObject, oroADar );

    string message = "premio dado por "+GetName(pcSpeaker)+" a "+GetName(targetObject)+": "+IntToString(xpADar)+" de xp, y "+IntToString(oroADar)+" de oro.";
    SendMessageToAllDMs( message  );
    WriteTimestampedLogEntry( message );
}

void XPW_darXp( object pcSpeaker, int xpADar );
void XPW_darXp( object pcSpeaker, int xpADar ) {
    object targetObject = GetLocalObject( pcSpeaker, XPW_targetObject_VN );
    Experience_dar( targetObject, xpADar );

    string message = "experiencia dada por "+GetName(pcSpeaker)+" a "+GetName(targetObject)+" = "+IntToString(xpADar);
    SendMessageToAllDMs( message  );
    WriteTimestampedLogEntry( message );
}

