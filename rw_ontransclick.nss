/** RandomWay - initiator and propagator transitions, on transition click event handler ***
Package: RandomWay - onTransitionClick
Author: Inquisidor
Description: A RandomWay is a list of areas where each one is linked, through propagator transitions, to one immediate previos and one immediate next areas.
The areas contained in the list, and also the transitions that link them, are randomly choosed from a pool of free (not already linked areas).
Given arbitrary areas A and B, contained in the RandomWay list, where B is the immediately after A, then:
The propagator transition in A that is coupled to a propagator transition in B, is called 'male transition'; and its couple in B is called 'female transition'.
Note that every area in a RandomWay instance has one, and only one, female transition. Also, every area, except the last, has one, and only one, propagator male transition.
The last area can optionaly have a male transition wich transports entering PCs to an exit or secondary entrance transition.
The first area female transition is coupled with the initiator transition, which is the one that:
    1) creates its own RandomWay instance if it is not already constructed
    2) is the entrance to the first area of its RandomWay instance
*******************************************************************************/
#include "RW_implement_inc"
#include "Party_generic"
#include "Location_tools"


void goToOtherArea( object user, object initiatorBody, object couple, object previousTransition, object destinationAreaBody, object arrivePoint );
void goToOtherArea( object user, object initiatorBody, object couple, object previousTransition, object destinationAreaBody, object arrivePoint ) {
    // OBJECT_SELF is the clicked coupled propagator or entrance
    // Skip the next block if this transition is implemented with a trap trigger and the previos traversed transition was the couple of this transition; because it means that this transition trigger was configured to use the onEnter or onTrapTriggered events (instead of the onTransitionClick event), and it was fired when the user arrived from the couple. So, the event must be ignored to avoid sending the user back to this transition couple.
    if(
        GetObjectType(OBJECT_SELF) != OBJECT_TYPE_TRIGGER
        || previousTransition != couple
        || !GetIsTrapped(OBJECT_SELF)
    ) {
        // if the destination area A belongs to a RandomWay instance RW, and it is virgin (nobody entered into A sinse it belogns to RW), execute the area setup script established by the initiator
        if( GetLocalInt( destinationAreaBody, RW_Area_isVirgin_VN ) ) {
            ExecuteScript( GetLocalString( initiatorBody, RW_Initiator_globalAreaSetupScript_PN ), couple );
            ExecuteScript( GetLocalString( destinationAreaBody, RW_Area_singularSetupScript_PN ), couple );
            DeleteLocalInt( destinationAreaBody, RW_Area_isVirgin_VN );
        }

        // select the area transition bitmap to show
        SetAreaTransitionBMP( GetLocalInt( destinationAreaBody , RW_Area_trasitionBitmapCode_PN ) );

        // if no special onTransitionScript was defined, transfer this transition user to the couple arrive point
        string onClickScript = GetLocalString( OBJECT_SELF, RW_Transition_onTransitScript_PN );
        if( onClickScript == "" ) {
            AssignCommand( user, JumpToObject(arrivePoint) );
            Party_jumpAllAssociatesToObject( user, arrivePoint );
        }
        // if a special onTransitionScript was defined, run the specified script instead. The specified script is responsible of transfering this transition user, if that is its intention.
        else
            ExecuteScript( onClickScript, OBJECT_SELF );
    }
}


void leaveClosedSector( object user, object previousTransition, object propagator );
void leaveClosedSector( object user, object previousTransition, object propagator ) {
    // OBJECT_SELF is the clicked deputy transition
    // if this transition is implemented with a trap trigger and the previos traversed transition was the couple of this transition, means that this transition trigger was configured to use the onEnter or onTrapTriggered events (instead of the onTransitionClick event), and it was fired when the user arrived from the couple. So, the event must be ignored to avoid sending the user back to this transition couple..
    if(
        GetObjectType(OBJECT_SELF) != OBJECT_TYPE_TRIGGER
        || previousTransition != propagator
        || !GetIsTrapped(OBJECT_SELF)
    ) {
        object arrivePoint = RW_Transition_getArrivePoint( propagator );
        AssignCommand( user, JumpToObject(arrivePoint) );
        Party_jumpAllAssociatesToObject( user, arrivePoint );

        // stop forcing the RandomSpawn system to put the encounters whose target is 'user' at the location pointed by 'arrivePoint' (instead of a randomly generated location).
        DeleteLocalObject( user, Location_PJ_punteroUbicacionForzada_VN );
    }
}


void enterClosedSector( object user, object previousTransition );
void enterClosedSector( object user, object previousTransition ) {
    object innerDoorOrCorridor = RW_Propagator_getAndConfigureInnerDeputyTransition(OBJECT_SELF);
    if(
        innerDoorOrCorridor != OBJECT_INVALID
        && (
            GetObjectType(OBJECT_SELF) != OBJECT_TYPE_TRIGGER
            || previousTransition != innerDoorOrCorridor
            || !GetIsTrapped(OBJECT_SELF)
        )
    ) {
        string onClickScript = GetLocalString( OBJECT_SELF, RW_Transition_onTransitScript_PN );
        if( onClickScript == "" ) {
            object arrivePoint = RW_Transition_getArrivePoint( innerDoorOrCorridor );
            AssignCommand( user, JumpToObject(arrivePoint) );
            Party_jumpAllAssociatesToObject( user, arrivePoint );
            // force the RandomSpawn system to put the encounters whose target is 'user' at the location pointed by 'arrivePoint' (instead of a randomly generated location).
            SetLocalObject( user, Location_PJ_punteroUbicacionForzada_VN, arrivePoint );
        } else
            ExecuteScript( onClickScript, OBJECT_SELF );
    }
}


void main() {

    object user = GetClickingObject();
    if( user == OBJECT_INVALID )
        user = GetLastUsedBy();

    // avoid creatures, that enter a transition implemented with a trap trigger, to be transfered.
    if( !GetIsPC(user) )
        return;

    // get the previous transition used by the user
    object previousTransition = GetLocalObject( user, RW_Pc_previousTransition_VN );
    // remember on the PC that this is the last coupled transition that he used, successfuly or not.
    SetLocalObject( user, RW_Pc_previousTransition_VN, OBJECT_SELF );

    // if the clicked transition is a propagator
    if( FindSubString( GetTag( OBJECT_SELF ), RW_Propagator_TAG_PREFIX ) == 0 ) {
        object couple = GetLocalObject( OBJECT_SELF, RW_Transition_couple_VN );
        // if this propagator not married (coupled to a transition in other area), check if it has a inner deputy in order to send the user to its closed sector.
        if( couple == OBJECT_INVALID ) {
            enterClosedSector( user, previousTransition );
        }
        // if married, send the user to this propagator couple arrive point
        else {
            object initiatorBody = GetLocalObject( GetArea(OBJECT_SELF), RW_Area_initiatorTransition_VN );
            object arrivePoint = RW_Transition_getArrivePoint( couple );
            object destinationAreaBody = GetArea(arrivePoint);
            goToOtherArea( user, initiatorBody, couple, previousTransition, destinationAreaBody, arrivePoint );
        }
    }
    else {

        // if the clicked transition is a inner deputy
        object outherDoorBody = GetLocalObject( OBJECT_SELF, RW_InnerDoor_outerDoorBody_VN );
        if( GetIsObjectValid(outherDoorBody) ) {
            leaveClosedSector( user, previousTransition, outherDoorBody );
        }

        // if the clicked transition is a RandomWay entrance
        else if( GetLocalInt( OBJECT_SELF, RW_Transition_typeCode_PN ) != 0 ) {
            object couple = RW_Entrance_getCouple( OBJECT_SELF, user );
            if( couple != OBJECT_INVALID ) {
                object arrivePoint = RW_Transition_getArrivePoint(couple);
                object destinationAreaBody = GetArea(arrivePoint);
                object initiatorBody = GetLocalObject( destinationAreaBody, RW_Area_initiatorTransition_VN );

                // Remember in the PC something that identifies the random way instance univocaly, in order to be able to know if the area where a PC logs in belongs to the same random way instance it belonged when this PC loged out.
                SetCampaignInt( RW_Pc_lastTraversedEntrance_DB, RW_Pc_rwInstanceIdOfTheLastTraversedEntrance_VN, RW_Initiator_getRandomWayInstanceId( initiatorBody ), user );
                // if the area where lays the cliqued transition is a normal area (do not belongs to a RandomWay instance), remember the entrance persistently in order to know where to send the PC after a logout-rebuild-login.
                if( GetLocalObject( GetArea(OBJECT_SELF), RW_Area_initiatorTransition_VN ) == OBJECT_INVALID )
                    SetCampaignString( RW_Pc_lastTraversedEntrance_DB, RW_Pc_lastTraversedEntranceTag_VN, GetTag(OBJECT_SELF), user );

                goToOtherArea( user, initiatorBody, couple, previousTransition, destinationAreaBody, arrivePoint );
            }
        }

        // if the clicked transition is unknown
        else if( GetIsPC(user) && !GetIsDM(user) && !GetIsDMPossessed(user) )
            SendMessageToPC( user, "RW_onTransClick: Error. Please report this message to the module maintainer: areaResRef="+GetResRef(GetArea(OBJECT_SELF))+", transitionTag="+GetTag(OBJECT_SELF) );
    }
}
