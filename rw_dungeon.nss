/******************** class Dungeon extends RandomWay *************************
Autor: Guido Gustavo Pollitzer (Inquisidor)
Version: 0.1
Descripcion: a RandomWay implementation.
*******************************************************************************/

#include "RW_RandomWay"
#include "RW_populaTools"

const string RW_Dungeon_TYPE_ID = "RW_Dungeon0";


int RW_Dungeon_constructor( struct Address this, object exitBody );
int RW_Dungeon_constructor( struct Address this, object exitBody ) {
    if( RW_debug ) WriteTimestampedLogEntry( "\n\nRW_Dungeon_constructor: begin" );

    object entranceBody = this.nbh;
    int numTripAreas = GetLocalInt( entranceBody, RW_Initiator_numberOfTripAreas_PN );
    int poolIndex = GetLocalInt( entranceBody, RW_DungeonEntrance_poolIndex_PN );
    int exitPoolIndex = GetLocalInt( exitBody, RW_DungeonExit_poolIndex_PN );

    // assertions
    if( numTripAreas <= 0 || ( exitBody != OBJECT_INVALID && exitPoolIndex == 0 ) ) {
        WriteTimestampedLogEntry( "RW_Dungeon_constructor: Invalid parameters" );
        return FALSE;
    }

    // base class constructor call
    if( !RW_RandomWay_constructor( this ) )
        return FALSE;
    Instance_setType( this, RW_Dungeon_TYPE_ID );
    // here begins the construction specific to a Dungeon

    struct RW_Pool pool = RW_Pool_get( entranceBody, poolIndex );

    int femalesFilterMask, femalesFilterValue, areasFilterMask, areasFilterValue, brotherFilterMask, brotherFilterValue;
    if( exitBody == OBJECT_INVALID ) {
        areasFilterMask = RW_Area_Char_CAN_GO_MALE_WAY|RW_Area_Char_CAN_GO_FEMALE_WAY;
        areasFilterValue = RW_Area_Char_CAN_GO_MALE_WAY|RW_Area_Char_CAN_GO_FEMALE_WAY;
        femalesFilterMask = RW_Transition_Char_IS_ARRIVE_ONLY;
        femalesFilterValue = 0;
        brotherFilterMask = RW_Transition_Char_IS_ARRIVE_ONLY;
        brotherFilterValue = 0;
    } else {
        areasFilterMask = RW_Area_Char_CAN_GO_MALE_WAY;
        areasFilterValue = RW_Area_Char_CAN_GO_MALE_WAY;
        femalesFilterMask = 0;
        femalesFilterValue = 0;
        brotherFilterMask = RW_Transition_Char_IS_ARRIVE_ONLY;
        brotherFilterValue = 0;
    }

    object maleTransitionBody = RW_RandomWay_addTripAreas(
        this, numTripAreas-1, entranceBody,
        femalesFilterMask, femalesFilterValue,
        (areasFilterMask|RW_Area_Char_CAN_BE_A_ROUTE), (areasFilterValue|RW_Area_Char_CAN_BE_A_ROUTE), pool,
        brotherFilterMask, brotherFilterValue,
        OBJECT_INVALID, poolIndex
    );
    if( RW_debug ) WriteTimestampedLogEntry( "\nRW_Dungeon_constructor: trecho" );

    maleTransitionBody = RW_RandomWay_addTripAreas(
        this, 1, maleTransitionBody,
        femalesFilterMask, femalesFilterValue,
        (areasFilterMask|RW_Area_Char_CAN_BE_DUNGEON_END), (areasFilterValue|RW_Area_Char_CAN_BE_DUNGEON_END), pool,
        (brotherFilterMask|RW_Transition_Char_CAN_BE_DUNGEON_EXIT), (brotherFilterValue|RW_Transition_Char_CAN_BE_DUNGEON_EXIT),
        exitBody, (exitBody == OBJECT_INVALID ? poolIndex : exitPoolIndex)
    );
    if( maleTransitionBody == OBJECT_INVALID ) {
        RW_RandomWay_destructor( this );
        return FALSE;
    }
    if( RW_debug ) WriteTimestampedLogEntry( "\nRW_Dungeon_constructor: final area" );

    SetLocalInt( GetArea(maleTransitionBody), RW_Area_isDungeonEnd_VN, TRUE );

    if( exitBody != OBJECT_INVALID ) {
        SetLocalObject( maleTransitionBody, RW_Transition_couple_VN, exitBody );
        SetLocalObject( exitBody, RW_Transition_couple_VN, maleTransitionBody );
        RW_Transition_enable( maleTransitionBody );
    }

    // determine the CR of the first area
    int firstAreaCr = GetLocalInt( this.nbh, RW_Initiator_firstAreaCr_PN );
    if( firstAreaCr == 0 ) {
        firstAreaCr = GetLocalInt( GetArea(this.nbh), RS_crArea_PN );
        if( firstAreaCr < 3 )
            firstAreaCr = 3;
    }
    // populate all areas
    RW_PopulationTools_populate( this, firstAreaCr, GetLocalString( this.nbh, RW_Initiator_defaultSge_PN ) );

    DeleteLocalInt( this.nbh, RW_Initiator_numConstructionRetries_VN );
    SetLocalInt( this.nbh, RW_Initiator_wayConstructionWasSuccessful_VN, TRUE );

    if( RW_debug ) WriteTimestampedLogEntry( "RW_Dungeon_constructor: end successfuly - lastMale="+GetTag(maleTransitionBody) );
    return TRUE;
}


// Advertenia: esta operacion (al igual que todas las que accedan a los
// elementos contenidos) requiere que el contenedor y todos los elementos
// contenidos sean vecinos.
void RW_Dungeon_destructor( struct Address this );
void RW_Dungeon_destructor( struct Address this ) { Instance_destructor( this ); }
void RW_Dungeon_destructor_UMC( struct Address this ) {

    object exitBody = RW_Transition_getExit( this.nbh );
    object lastAreaMaleBody = GetLocalObject( exitBody, RW_Transition_couple_VN );
    DeleteLocalObject( lastAreaMaleBody, RW_Transition_couple_VN );
    DeleteLocalObject( exitBody, RW_Transition_couple_VN );
    DeleteLocalInt( GetArea(lastAreaMaleBody), RW_Area_isDungeonEnd_VN );

    RW_RandomWay_destructor_UMC( this );
}


int RW_Dungeon_isEqual( struct Address this, struct Address other );
int RW_Dungeon_isEqual( struct Address this, struct Address other ) { return Instance_isEqual( this, other ); }
int RW_Dungeon_isEqual_UMC( struct Address this, struct Address other ) {
    PrintString( "RW_Dungeon_isEqual: not implemented" );
    return -1;
}


string RW_Dungeon_toText( struct Address this);
string RW_Dungeon_toText( struct Address this) { return Instance_toText( this ); }
string RW_Dungeon_toText_UMC( struct Address this) {
    PrintString( "RW_Dungeon_toText: not implemented" );
    return "";
}

int RW_Dungeon_isAnyPcInside( struct Address this );
int RW_Dungeon_isAnyPcInside( struct Address this ) {
    return RW_RandomWay_isAnyPcInside( this );
    // TODO <---------------------------------------------------------------
}



