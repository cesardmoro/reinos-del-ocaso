/**************** RandomWay - high dependent code ******************************
Package: RandomWay - high dependent code
Author: Inquisidor
Description: A RandomWay is a list of areas where each one is linked, through propagator transitions, to one immediate previos and one immediate next areas.
The areas contained in the list, and also the transitions that link them, are randomly choosed from a pool of free (not already linked areas).
Given arbitrary areas A and B, contained in the RandomWay list, where B is the immediately after A, then:
The propagator transition in A that is coupled to a propagator transition in B, is called 'male transition'; and its couple in B is called 'female transition'.
Note that every area in a RandomWay instance has one, and only one, female transition. Also, every area, except the last, has one, and only one, male transition.
The last area can optionaly have a male transition wich transports entering PCs to an exit or secondary entrance transition.
The first area female transition is coupled with the initiator transition, which is the one that:
    1) creates its own RandomWay instance if it is not already constructed
    2) is the entrance to the first area of its RandomWay instance
*******************************************************************************/
#include "RW_facade_inc"
#include "RW_Shortcut"
#include "RW_Dungeon"
#include "DateTime"
#include "RTG_inc"

int RW_RandomWay_mustBeConstructed( struct Address randomWay, object user );
int RW_RandomWay_mustBeConstructed( struct Address randomWay, object user ) {
    if( !Instance_isConstructed( randomWay ) )
        return TRUE;
    else {
        // if the random way construction terminated abruptly (TOO MANY INSTRUCTION, DIVIDE BY CERO, etc).
        if( !GetLocalInt( randomWay.nbh, RW_Initiator_wayConstructionWasSuccessful_VN ) ) {
            SendMessageToPC( user, "//Cleaning the abruptly terminated random way. Please, try to enter again." );
            RW_RandomWay_destructor( randomWay );
        }
        // if the expiration date was reached and no PC is inside
        else if (
            DateTime_getActual() > GetLocalInt( randomWay.nbh, RW_Initiator_expirationDateTime_VN )
            && !RW_Shortcut_isAnyPcInside( randomWay )
        ) {
            SendMessageToPC( user, "//Cleaning the previous random way construction. Please, try to enter again." );
            RW_RandomWay_destructor( randomWay );
        }
    }
    return FALSE;
}


int RW_Transition_buildDungeonIfNecesary( object entranceBody, object exitBody, object user );
int RW_Transition_buildDungeonIfNecesary( object entranceBody, object exitBody, object user ) {

    struct Address dungeon = Address_create( entranceBody, RW_Initiator_randomWayInstance_VN );
    if( RW_RandomWay_mustBeConstructed( dungeon, user ) )
        return RW_Dungeon_constructor( dungeon, exitBody );
    return TRUE;
}


int RW_Transition_buildShortcutIfNecesary( object primaryEntranceBody, object secondaryEntranceBody, object user );
int RW_Transition_buildShortcutIfNecesary( object primaryEntranceBody, object secondaryEntranceBody, object user ) {

    struct Address shortcut = Address_create( primaryEntranceBody, RW_Initiator_randomWayInstance_VN );
    if( RW_RandomWay_mustBeConstructed( shortcut, user ) )
        return RW_Shortcut_constructor( shortcut, secondaryEntranceBody );
    return TRUE;
}


object RW_Entrance_getCouple( object thisEntranceBody, object messageTargetPc );
object RW_Entrance_getCouple( object thisEntranceBody, object messageTargetPc ) {
    string message = RW_Initiator_MESSAGE_TO_SEND_WHEN_THE_RANDOMWAY_CONSTRUCTION_WAS_NOT_SUCCESSFUL;
    int theRamdomWayWasSuccessfulyConstructed;
    switch( GetLocalInt( thisEntranceBody, RW_Transition_typeCode_PN ) ) {
        case RW_Transition_TypeCode_DUNGEON_ENTRANCE:
            theRamdomWayWasSuccessfulyConstructed = RW_Transition_buildDungeonIfNecesary( thisEntranceBody, RW_Transition_getExit( thisEntranceBody ), messageTargetPc );
            break;

        case RW_Transition_TypeCode_DUNGEON_EXIT:
            theRamdomWayWasSuccessfulyConstructed = FALSE;
            message = "RW_Entrance_getCouple: Error! This transition is one way only, and you are trying to go in the oposite direction. Please tell the module mapper about this inconvenient. areaResRef="+GetResRef(GetArea(thisEntranceBody))+", entranceTag="+GetTag(thisEntranceBody);
            break;

        case RW_Transition_TypeCode_SHORTCUT_PRIMARY_ENTRANCE:
            theRamdomWayWasSuccessfulyConstructed = RW_Transition_buildShortcutIfNecesary( thisEntranceBody, RW_Transition_getSecondaryEntrance( thisEntranceBody ), messageTargetPc );
            break;

        case RW_Transition_TypeCode_SHORTCUT_SECONDARY_ENTRANCE:
            theRamdomWayWasSuccessfulyConstructed = RW_Transition_buildShortcutIfNecesary( RW_Transition_getPrimaryEntrance( thisEntranceBody ), thisEntranceBody, messageTargetPc );
            break;

        default:
            theRamdomWayWasSuccessfulyConstructed = FALSE;
            message = "RW_Entrance_getCouple: Error! Invalid parameter: areaResRef="+GetResRef(GetArea(thisEntranceBody))+", entranceTag="+GetTag(thisEntranceBody);
            break;
    }

    if( theRamdomWayWasSuccessfulyConstructed ) {
        return GetLocalObject( thisEntranceBody, RW_Transition_couple_VN );
    } else {
        FloatingTextStringOnCreature( message, messageTargetPc );
        return OBJECT_INVALID;
    }
}


// gets the location of the point to where 'thisTransitionBody' should transfer the incoming PC
location RW_Transition_getTargetLocation( object thisTransitionBody=OBJECT_SELF );
location RW_Transition_getTargetLocation( object thisTransitionBody=OBJECT_SELF ) {
//    SendMessageToPC( GetFirstPC(), "RW_Transition_getTargetLocation: selfTag="+GetTag(OBJECT_SELF)+", coupleTag="+GetTag(GetLocalObject( thisTransitionBody, RW_Transition_couple_VN ))+", targetObjectTag="+GetTag(RW_Transition_getArrivePoint( GetLocalObject( thisTransitionBody, RW_Transition_couple_VN ) )) );
    return GetLocation( RW_Transition_getArrivePoint( GetLocalObject( thisTransitionBody, RW_Transition_couple_VN ) ) );
}


object RW_Door_getOtherSide( object this );
object RW_Door_getOtherSide( object this ) {
    object otherSideBody;
    // if this is a propagator transition
    if( FindSubString( GetTag(this), RW_Propagator_TAG_PREFIX ) == 0 ) {
        otherSideBody = GetLocalObject( this, RW_Transition_couple_VN );
        if( otherSideBody == OBJECT_INVALID )
            otherSideBody = RW_Propagator_getAndConfigureInnerDeputyTransition( this );
    }

    // if this is an entrance transition
    else if( GetLocalInt( this, RW_Transition_typeCode_PN ) != 0 )
        otherSideBody = GetLocalObject( this, RW_Transition_couple_VN );

    // if this isn't a propagator nor an initiator, it can be an inner door
    else
        otherSideBody = GetLocalObject( this, RW_InnerDoor_outerDoorBody_VN );

    return otherSideBody;
}


void RW_Dungeon_createFinalReward( object initiator, object container, float fractionCorrespondingToContainer );
void RW_Dungeon_createFinalReward( object initiator, object container, float fractionCorrespondingToContainer ) {
    float totalReward = GetLocalFloat( initiator, RW_Initiator_totalNominalReward_VN );
    float partialReward = fractionCorrespondingToContainer * totalReward;
    float consumedReward = GetLocalFloat( initiator, RW_Initiator_consumedNominalReward_VN );
    float remainingReward = totalReward - consumedReward;
    if( partialReward > remainingReward )
        partialReward = remainingReward;
    SetLocalFloat( initiator, RW_Initiator_consumedNominalReward_VN, consumedReward + partialReward );

//    SendMessageToPC( GetFirstPC(), "RW_Dungeon_createFinalReward: racialType="+IntToString(GetRacialType(container))+", totalReward="+FloatToString(totalReward)+", remainingReward="+FloatToString(remainingReward) );

    float areaCr = IntToFloat( GetLocalInt( GetArea(container), RS_crArea_PN ) );
    float desiredCr = Random_exponentialDistribution( areaCr, IPS_crToLevel(areaCr) );
    RTG_determineLoot( container, desiredCr, 0.80*partialReward, OBJECT_INVALID ); // note that the expectance of the total of the final reward will be 80% of the sum of all rewards given by the killed creatures that belong to the random way instance.
}
