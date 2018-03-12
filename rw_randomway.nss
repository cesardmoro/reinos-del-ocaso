/*************************** class RandomWay implements Instance ******************************
Autor: Guido Gustavo Pollitzer (Inquisidor)
Version: 0.1
Descripcion: ramdom way.
******************************************************************************************/

#include "Fwk_Instance"
#include "Fwk_object"
#include "RW_facade_inc"
#include "Ctnr_VectorObj"
#include "DateTime"


const string RW_RandomWay_TYPE_ID = "RW_RandomWay0";

const string RW_RandomWay_femaleTransitionsList_FIELD = ".cftl"; // [Ctnr_VectorObj] contains all the coupled female transitions in this RandomWay


////////////////////// Forward Declarations ////////////////////////////////////

void RW_PoolsManager_recoverIdleAreas( object this, int recollectionIntensity );


/////////////////////// operations /////////////////////////////////////////////

// Advertenia: esta operacion (al igual que todas las que accedan a los
// elementos contenidos) requiere que el contenedor y todos los elementos
// contenidos sean vecinos.
void RW_RandomWay_destructor( struct Address this );
void RW_RandomWay_destructor( struct Address this ) { Instance_destructor( this ); }
void RW_RandomWay_destructor_UMC( struct Address this ) {

    object initiator = this.nbh;
    if( GetObjectType(initiator)==OBJECT_TYPE_DOOR ) {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( GetMaxHitPoints(initiator)-GetCurrentHitPoints(initiator) ), initiator );
        if( GetIsOpen(initiator) )
            ActionCloseDoor( initiator );
    }

    struct Address femaleTransitionsList = this;
    femaleTransitionsList.path += RW_RandomWay_femaleTransitionsList_FIELD;

    int iteratedIndex = VectorObj_getSize( femaleTransitionsList );
    while( --iteratedIndex >= 0 ) {
        object iteratedFemaleTransition = VectorObj_getAt( femaleTransitionsList, iteratedIndex );

        object iteratedArea = GetArea( iteratedFemaleTransition );
        DeleteLocalObject( iteratedArea, RW_Area_initiatorTransition_VN );
        DeleteLocalObject( iteratedArea, RW_Area_femaleTransition_VN );
        DeleteLocalObject( iteratedArea, RW_Area_maleTransition_VN );

        if( RW_debug ) WriteTimestampedLogEntry( "RW_RandomWay_destructor: area="+GetTag(iteratedArea) );

        object iteratedMaleTransition = GetLocalObject( iteratedFemaleTransition, RW_Transition_couple_VN );
        DeleteLocalObject( iteratedMaleTransition, RW_Transition_couple_VN );
        DeleteLocalObject( iteratedFemaleTransition, RW_Transition_couple_VN );

        RW_Area_hideAllPropagatorTriggersAndCloseAllDoors( iteratedArea );
    }
    VectorObj_destructor( femaleTransitionsList );

    Instance_destructor_UMC( this );
}


object RW_RandomWay_addTripAreas( struct Address this, int numTripAreas, object maleTransitionBody, int femaleFilterMask, int femaleFilterValue, int areaFilterMask, int areaFilterValue, struct RW_Pool pool, int brotherFilterMask, int brotherFilterValue, object sisterInLawBody, int nextAreaPoolIndex );
object RW_RandomWay_addTripAreas( struct Address this, int numTripAreas, object maleTransitionBody, int femaleFilterMask, int femaleFilterValue, int areaFilterMask, int areaFilterValue, struct RW_Pool pool, int brotherFilterMask, int brotherFilterValue, object sisterInLawBody, int nextAreaPoolIndex ) {
    if( maleTransitionBody == OBJECT_INVALID )
        return OBJECT_INVALID;

    struct Address femaleTransitionsList = this;
    femaleTransitionsList.path += RW_RandomWay_femaleTransitionsList_FIELD;

    struct WeightedSelector eligibleAreasWs = RW_Pool_getEligibleAreasWs( pool );

    int areAllTransitionsOriented = TRUE;
    int orientationDiscrepancy = 0;

    int alreadyBuildAreasCounter;
    for( alreadyBuildAreasCounter = 0; alreadyBuildAreasCounter < numTripAreas; ++alreadyBuildAreasCounter ) {
        object wifeBody = RW_Transition_seekWife( maleTransitionBody, eligibleAreasWs, areaFilterMask, areaFilterValue, femaleFilterMask, femaleFilterValue );
        if( wifeBody == OBJECT_INVALID ) {
            return OBJECT_INVALID;
        }
        object areaBody = GetArea( wifeBody );
        SetLocalInt( areaBody, RW_Area_isVirgin_VN, TRUE );
        object nextMaleTransitionBody = RW_Area_seekBrotherOf( areaBody, brotherFilterMask, brotherFilterValue, wifeBody, pool.defaultPermitedPoolsForDoorsDestination, pool.defaultPermitedPoolsForOrientedTriggersDestination, sisterInLawBody, nextAreaPoolIndex );
        if( nextMaleTransitionBody == OBJECT_INVALID ) {
            return OBJECT_INVALID;
        }

        int femaleOrientationCode = RW_Transition_getOrientationCode( wifeBody );
        int maleOrientationCode = RW_Transition_getOrientationCode( maleTransitionBody );
        areAllTransitionsOriented &= maleOrientationCode > 0 && femaleOrientationCode > 0;
        orientationDiscrepancy += 6 + femaleOrientationCode - maleOrientationCode;
        orientationDiscrepancy = orientationDiscrepancy % 4;

        RW_Transition_enable( maleTransitionBody );
        RW_Transition_enable( wifeBody );

        SetLocalObject( wifeBody, RW_Transition_couple_VN, maleTransitionBody );
        SetLocalObject( maleTransitionBody, RW_Transition_couple_VN, wifeBody );
        SetLocalObject( areaBody, RW_Area_maleTransition_VN, nextMaleTransitionBody );
        SetLocalObject( areaBody, RW_Area_femaleTransition_VN, wifeBody );
        SetLocalObject( areaBody, RW_Area_initiatorTransition_VN, this.nbh );
        VectorObj_pushBack( femaleTransitionsList, wifeBody );

        maleTransitionBody = nextMaleTransitionBody;
    } // Note that the male transition of the last area is not coupled.

    return maleTransitionBody;
}


int RW_RandomWay_constructor( struct Address this );
int RW_RandomWay_constructor( struct Address this ) {
    if( RW_debug ) WriteTimestampedLogEntry( "RW_RandomWay_constructor: begin" );
    // parent is an interface
    object initiatorTransitionBody = this.nbh;
    if( !GetIsObjectValid( initiatorTransitionBody ) )
        return FALSE;
    Instance_setType( this, RW_RandomWay_TYPE_ID );

    // set the successful construction mark to FALSE
    DeleteLocalInt( this.nbh, RW_Initiator_wayConstructionWasSuccessful_VN );

    // initialice the femaleTransitionsList
    struct Address femaleTransitionsList = this;
    femaleTransitionsList.path += RW_RandomWay_femaleTransitionsList_FIELD;
    VectorObj_constructor( femaleTransitionsList );

    // set the expiration time to one hour after the actual time, plus the 'rebuildPeriodModInMinutes'
    SetLocalInt(
        initiatorTransitionBody,
        RW_Initiator_expirationDateTime_VN,
        DateTime_getActual() + 3600 + 60*GetLocalInt( initiatorTransitionBody, RW_Initiator_rebuildPeriodModInMinutes_PN )
    );

    object poolsManager = RW_PoolsManager_getSingleton();
    if( !GetLocalInt( this.nbh, RW_Initiator_isRegistered_VN ) ) {
        RW_PoolsManager_register( poolsManager, this.nbh );
        SetLocalInt( this.nbh, RW_Initiator_isRegistered_VN, TRUE );
    }

    int numConstructionRetries = GetLocalInt( this.nbh, RW_Initiator_numConstructionRetries_VN );
    RW_PoolsManager_recoverIdleAreas( poolsManager, numConstructionRetries );
    SetLocalInt( this.nbh, RW_Initiator_numConstructionRetries_VN, 1 + numConstructionRetries );

    if( RW_debug ) WriteTimestampedLogEntry( "RW_RandomWay_constructor: end - retries="+IntToString(numConstructionRetries) );
    return TRUE;
}


int RW_RandomWay_isEqual( struct Address this, struct Address other );
int RW_RandomWay_isEqual( struct Address this, struct Address other ) { return Instance_isEqual( this, other ); }
int RW_RandomWay_isEqual_UMC( struct Address this, struct Address other ) {
    PrintString( "RW_RandomWay_isEqual: not implemented" );
    return -1;
}


string RW_RandomWay_toText( struct Address this);
string RW_RandomWay_toText( struct Address this) { return Instance_toText( this ); }
string RW_RandomWay_toText_UMC( struct Address this) {
    PrintString( "RW_RandomWay_toText: not implemented" );
    return "";
}


int RW_RandomWay_isAnyPcInside( struct Address this );
int RW_RandomWay_isAnyPcInside( struct Address this ) {

    object iteratedPc = GetFirstPC();
    while( iteratedPc != OBJECT_INVALID ) {
        object area = GetArea( iteratedPc );
        if( !GetIsObjectValid( area ) )
            area = GetArea( GetLocalObject( iteratedPc, RW_Pc_previousTransition_VN ) );
        if( GetIsObjectValid( area ) ) {
            object initiatorTransitionBody = GetLocalObject( area, RW_Area_initiatorTransition_VN );
            if( initiatorTransitionBody == this.nbh )
                return TRUE;
        }
        iteratedPc = GetNextPC();
    }
    return FALSE;
}


int RW_RandomWay_hasExpired( struct Address this, int actualDateTime );
int RW_RandomWay_hasExpired( struct Address this, int actualDateTime ) {
    return GetLocalInt( this.nbh, RW_Initiator_expirationDateTime_VN ) + 60*GetLocalInt( this.nbh, RW_Initiator_rebuildPeriodModInMinutes_PN );
}


void RW_PoolsManager_recoverIdleAreas( object this, int recollectionIntensity ) {
    struct Address registeredInitiators = Address_create( this, RW_PoolsManager_registeredInitiators_VN );
    int actualDateTime = DateTime_getActual();

    if( recollectionIntensity > 0 ) {
        int iteratedIndex = VectorObj_getSize( registeredInitiators );
        while( --iteratedIndex >= 0 ) {
            object initiator = VectorObj_getAt( registeredInitiators, iteratedIndex );
            struct Address iteratedRandomWay = Address_create( initiator, RW_Initiator_randomWayInstance_VN );
            if(
                !RW_RandomWay_isAnyPcInside( iteratedRandomWay )
                && (
                    recollectionIntensity >= 4
                    || (
                        recollectionIntensity >= 2
                        && actualDateTime > GetLocalInt( iteratedRandomWay.nbh, RW_Initiator_expirationDateTime_VN )
                    )
                )
            ) {
                RW_RandomWay_destructor( iteratedRandomWay );
            }
        }
    }
}

