/******************** class Shortcut extends RandomWay *************************
Autor: Guido Gustavo Pollitzer (Inquisidor)
Version: 0.1
Descripcion: ramdom way.
*******************************************************************************/

#include "RW_RandomWay"
#include "RW_populaTools"

const string RW_Shortcut_TYPE_ID = "RW_Shortcut0";

const int RW_Shortcut_Direction_DOUBLE_WAY = 0;
const int RW_Shortcut_Direction_FROM_PRIMARY_TO_SECONDARY = 1;
const int RW_Shortcut_Direction_FROM_SECONDARY_TO_PRIMARY = 2;

int RW_Shortcut_constructor( struct Address this, object secondaryEntranceBody, int direction=RW_Shortcut_Direction_DOUBLE_WAY );
int RW_Shortcut_constructor( struct Address this, object secondaryEntranceBody, int direction=RW_Shortcut_Direction_DOUBLE_WAY ) {
    if( RW_debug ) WriteTimestampedLogEntry( "\n\nRW_Shortcut_constructor: begin" );

    object primaryEntranceBody = this.nbh;
    int numTripAreas = GetLocalInt( primaryEntranceBody, RW_Initiator_numberOfTripAreas_PN );
    int untilPortalPoolIndex = GetLocalInt( primaryEntranceBody, RW_ShortcutPrimaryEntrance_untilPortalPoolIndex_PN );
    int afterPortalPoolIndex = GetLocalInt( primaryEntranceBody, RW_ShortcutPrimaryEntrance_afterPortalPoolIndex_PN );
    int secondaryEntrancePoolIndex = GetLocalInt( secondaryEntranceBody, RW_ShortcutSecondaryEntrance_poolIndex_PN );

    // assertions
    if( !GetIsObjectValid( secondaryEntranceBody ) || numTripAreas <= 0 || untilPortalPoolIndex == 0 || afterPortalPoolIndex == 0 || secondaryEntrancePoolIndex == 0 )
        return FALSE;

    // base class constructor call
    if( !RW_RandomWay_constructor( this ) )
        return FALSE;
    Instance_setType( this, RW_Shortcut_TYPE_ID );
    // here begins the construction specific to a Shortcut

    struct RW_Pool untilPortalPool = RW_Pool_get( primaryEntranceBody, untilPortalPoolIndex );
    struct RW_Pool afterPortalPool = RW_Pool_get( primaryEntranceBody, afterPortalPoolIndex );

    int femalesFilterMask, femalesFilterValue, areasFilterMask, areasFilterValue, brotherFilterMask, brotherFilterValue;
    switch( direction ) {
        case RW_Shortcut_Direction_DOUBLE_WAY:
            areasFilterMask = RW_Area_Char_CAN_BE_A_ROUTE|RW_Area_Char_CAN_GO_MALE_WAY|RW_Area_Char_CAN_GO_FEMALE_WAY;
            areasFilterValue = RW_Area_Char_CAN_BE_A_ROUTE|RW_Area_Char_CAN_GO_MALE_WAY|RW_Area_Char_CAN_GO_FEMALE_WAY;
            femalesFilterMask = RW_Transition_Char_IS_ARRIVE_ONLY;
            femalesFilterValue = 0;
            brotherFilterMask = RW_Transition_Char_IS_ARRIVE_ONLY;
            brotherFilterValue = 0;
            break;
        case RW_Shortcut_Direction_FROM_PRIMARY_TO_SECONDARY:
            areasFilterMask = RW_Area_Char_CAN_BE_A_ROUTE|RW_Area_Char_CAN_GO_MALE_WAY;
            areasFilterValue = RW_Area_Char_CAN_BE_A_ROUTE|RW_Area_Char_CAN_GO_MALE_WAY;
            femalesFilterMask = 0;
            femalesFilterValue = 0;
            brotherFilterMask = RW_Transition_Char_IS_ARRIVE_ONLY;
            brotherFilterValue = 0;
            break;
        case RW_Shortcut_Direction_FROM_SECONDARY_TO_PRIMARY:
            areasFilterMask = RW_Area_Char_CAN_BE_A_ROUTE|RW_Area_Char_CAN_GO_FEMALE_WAY;
            areasFilterValue = RW_Area_Char_CAN_BE_A_ROUTE|RW_Area_Char_CAN_GO_FEMALE_WAY;
            femalesFilterMask = RW_Transition_Char_IS_ARRIVE_ONLY;
            femalesFilterValue = 0;
            brotherFilterMask = 0;
            brotherFilterValue = 0;
            break;
        default:
            return FALSE;
    }

    int portalAreaIndex = Random( numTripAreas );
    object maleTransitionBody = RW_RandomWay_addTripAreas(
        this, portalAreaIndex, primaryEntranceBody,
        femalesFilterMask, femalesFilterValue,
        areasFilterMask, areasFilterValue, untilPortalPool,
        brotherFilterMask, brotherFilterValue,
        OBJECT_INVALID, untilPortalPoolIndex
    );
    if( RW_debug ) WriteTimestampedLogEntry( "\nRW_Shortcut_constructor: primer trecho - portal" );
    maleTransitionBody = RW_RandomWay_addTripAreas(
        this, 1, maleTransitionBody,
        femalesFilterMask, femalesFilterValue,
        (areasFilterMask|RW_Area_Char_HAS_A_TELEPORTER), (areasFilterValue|RW_Area_Char_HAS_A_TELEPORTER), untilPortalPool,
        (brotherFilterMask|RW_Transition_Char_IS_TELEPORTER), (brotherFilterValue|RW_Transition_Char_IS_TELEPORTER),
        OBJECT_INVALID, afterPortalPoolIndex
    );
    if( RW_debug ) WriteTimestampedLogEntry( "\nRW_Shortcut_constructor: portal - segundo trecho" );
    maleTransitionBody = RW_RandomWay_addTripAreas(
        this, numTripAreas - portalAreaIndex - 1, maleTransitionBody,
        femalesFilterMask, femalesFilterValue,
        areasFilterMask, areasFilterValue, afterPortalPool,
        brotherFilterMask, brotherFilterValue,
        OBJECT_INVALID, afterPortalPoolIndex
    );
    if( RW_debug ) WriteTimestampedLogEntry( "\nRW_Shortcut_constructor: segundo trecho - ultimo area" );
    maleTransitionBody = RW_RandomWay_addTripAreas(
        this, 1, maleTransitionBody,
        femalesFilterMask, femalesFilterValue,
        areasFilterMask, areasFilterValue, afterPortalPool,
        brotherFilterMask, brotherFilterValue,
        secondaryEntranceBody, secondaryEntrancePoolIndex
    );
    if( maleTransitionBody == OBJECT_INVALID ) {
        RW_RandomWay_destructor( this );
        return FALSE;
    }

    SetLocalObject( maleTransitionBody, RW_Transition_couple_VN, secondaryEntranceBody );
    SetLocalObject( secondaryEntranceBody, RW_Transition_couple_VN, maleTransitionBody );
    RW_Transition_enable( maleTransitionBody );

    if( !RW_PopulationTools_populateShortcut( this, secondaryEntranceBody, GetLocalString( this.nbh, RW_Initiator_defaultSge_PN ) ) )
        return FALSE;

    DeleteLocalInt( this.nbh, RW_Initiator_numConstructionRetries_VN );
    SetLocalInt( this.nbh, RW_Initiator_wayConstructionWasSuccessful_VN, TRUE );

    if( RW_debug ) WriteTimestampedLogEntry( "RW_Shortcut_constructor: end successfuly - lastMale="+GetTag(maleTransitionBody) );
    return TRUE;
}


// Advertenia: esta operacion (al igual que todas las que accedan a los
// elementos contenidos) requiere que el contenedor y todos los elementos
// contenidos sean vecinos.
void RW_Shortcut_destructor( struct Address this );
void RW_Shortcut_destructor( struct Address this ) { Instance_destructor( this ); }
void RW_Shortcut_destructor_UMC( struct Address this ) {
    object secondaryEntranceBody = RW_Transition_getSecondaryEntrance( this.nbh );
    object lastAreaMaleBody = GetLocalObject( secondaryEntranceBody, RW_Transition_couple_VN );
    DeleteLocalObject( lastAreaMaleBody, RW_Transition_couple_VN );
    DeleteLocalObject( secondaryEntranceBody, RW_Transition_couple_VN );

    RW_RandomWay_destructor_UMC( this );
}


int RW_Shortcut_isEqual( struct Address this, struct Address other );
int RW_Shortcut_isEqual( struct Address this, struct Address other ) { return Instance_isEqual( this, other ); }
int RW_Shortcut_isEqual_UMC( struct Address this, struct Address other ) {
    PrintString( "RW_Shortcut_isEqual: not implemented" );
    return -1;
}


string RW_Shortcut_toText( struct Address this);
string RW_Shortcut_toText( struct Address this) { return Instance_toText( this ); }
string RW_Shortcut_toText_UMC( struct Address this) {
    PrintString( "RW_Shortcut_toText: not implemented" );
    return "";
}

int RW_Shortcut_isAnyPcInside( struct Address this );
int RW_Shortcut_isAnyPcInside( struct Address this ) {
    return RW_RandomWay_isAnyPcInside( this );
    // TODO <---------------------------------------------------------------
}


