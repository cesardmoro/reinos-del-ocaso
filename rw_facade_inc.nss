/*************** RandomWay - low dependent code  *******************************
Package: RandomWay - low dependent code
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
#include "Random_inc"
#include "Fwk_Instance"
#include "Ctnr_VectorObj"

const int RW_debug = FALSE;

///////////////////////// Data bases and registers names ///////////////////////

const string RW_Pc_lastTraversedEntrance_DB = "RWlte";
const string RW_Pc_lastTraversedEntranceTag_VN = "RWltet"; // [string] tag of the last entrance transition traversed by this PC in the entrance toward propagatr direction.
const string RW_Pc_rwInstanceIdOfTheLastTraversedEntrance_VN = "RWlteed"; // [int] identifier of the last RandomWay instance this PC has intered into. This value is set when the PC traverses a RandomWay entrance in the entrance toward propagator direction.


///////////////////////// Pool constants ///////////////////////////////////////
// The areas contained by a single pool must be build with tilesets that are very similar, in order to avoid intuitively incoherent transitions.
// Because the standard tilesets are all very different compared to each other, all the pools whose index is defined below contain areas build with a single tileset.
// This fact leads me to use the tileset name for naming the pool index constant.

// This four pool indexes are designated to embrace all the tilesets that are not used to build independent areas to be used by the RandomWay.
// The pool descriptor script can return an empty array of areas when this indexes are received.
// The only reason for their existence is to describe, aproximately, the tileset of an normal area whose tileset is not similar to any of the tileset used by any pool. This is necesary in order to be able to set the value of the 'poolIndex' property of the DungeonExit and ShortcutSecondaryEntrance transition that lie in normal areas whose tileset is not similar to any of the tilesets used by any pool.
const int RW_Pool_Index_GENERIC_ARTIFICIAL_EXTERIOR = 1;
const int RW_Pool_Index_GENERIC_ARTIFICIAL_INTERIOR = 2;
const int RW_Pool_Index_GENERIC_NATURAL_EXTERIOR = 3;
const int RW_Pool_Index_GENERIC_NATURAL_INTERIOR = 4;

// This are the already defined pool indexes for pools that are expected to contain independent areas.
const int RW_Pool_Index_BEHOLDER_CAVES = 5;
const int RW_Pool_Index_CRYPT = 6;
const int RW_Pool_Index_DROW_INTERIOR = 7;
const int RW_Pool_Index_DUNGEON = 8;
const int RW_Pool_Index_ILLITHID_INTERIOR = 9;
const int RW_Pool_Index_MINES_AND_CAVERNS = 10;
const int RW_Pool_Index_RUINS = 11;
const int RW_Pool_Index_SEWERS = 12;
const int RW_Pool_Index_UNDERDARK = 13;

// This commented constants are candidates to become valid pool indexes, if someone builds areas with this tilesets.
//const int RW_Pool_Index_CASTLE_INTERIOR = ?;
//const int RW_Pool_Index_CITY_EXTERIOR = ?;
//const int RW_Pool_Index_CITY_INTERIOR = ?;
//const int RW_Pool_Index_DESERT = ?;
//const int RW_Pool_Index_FOREST = ?;
//const int RW_Pool_Index_FROZEN_WASTES = ?;
//const int RW_Pool_Index_MICRO_SET = ?;
//const int RW_Pool_Index_RURAL = ?;
//const int RW_Pool_Index_RURAL_WINTER = ?;

///////////////////////// Area constants ///////////////////////////////////////

//name of the script which will be called by the RW_onAreaEnter script every time it is called, except when the entering object is a PC that is loging in into an area that don't belongs to the RandomWay instance it belonged when the entering PC left loged off.
const string RW_COMMON_AREA_ON_ENTER_SCRIPT = "def_area_onenter"; // name of the script which will be called by the RW_Area_onEnter script every time it is called, except when the entering object is a PC that is loging in into an area that don't belongs to the RandomWay instance it belonged when the entering PC left loged off.
const string RW_COMMON_AREA_ON_EXIT_SCRIPT = "def_area_onexit"; // name of the script which will be called by the RW_Area_onExit script every time it is called, except when the exiting object is a PC that is loging in into an area that don't belongs to the RandomWay instance it belonged when the entering PC left loged off.

//Binary Characteristics Set //
const int RW_Area_Char_CAN_BE_A_ROUTE = 1;
const int RW_Area_Char_CAN_GO_MALE_WAY = 2;         // Exist a female able propagator F, and a male able propagator M, such that M can be reached starting in F. Note that strictly unidierectional areas must set the sex restriction code on all its propagators
const int RW_Area_Char_CAN_GO_FEMALE_WAY = 4;       // Exist a female able propagator M, and a male able propagator F, such that F can be reached starting in M. Note that strictly unidierectional areas must set the sex restriction code on all its propagators
const int RW_Area_Char_HAS_A_TELEPORTER = 8;        // Has a departure teleporter (do not includes teleport arrive point like summoning circles).
const int RW_Area_Char_CAN_BE_DUNGEON_END = 16;


///////////////////////// Area properties //////////////////////////////////////

const string RW_Area_isOriented_PN = "RWAio";           // [int] tells if this area is oriented. In oriented areas, the propagator transitions must extricly have, when behaving as a female, the oposite orientation than is male couple. By default, interior areas are unoriented. This property changes the default behavior of interior areas.
const string RW_Area_isUnoriented_PN= "RWAiu";          // [int] tells if this area is unoriented. In unoriented areas, the player have to ignore the magnetic needle (brújula). By default, exterior areas are oriented. This property changes the default behavior of exterior areas.
const string RW_Area_singularSetupScript_PN = "RWAsss"; // [string] script that is executed the first time any of the transitions that are coupled to a propagator transition of this area, is clicked. OBJECT_SELF will be the couple C of the clicked transition. Note that C lays in this area. Useful to do preparations that are specific to this area. This script is executed after the area setup script that is specified with RW_Initiator_globalAreaSetupScript_PN in the initiator transition that constructed the RandomWay instance this area belongs to.
const string RW_Area_trasitionBitmapCode_PN = "RWAtbc"; // [int] code of the transition bitmap that is showed along the area loading progress indicator when a player comes into this area.
//const string RW_Area_binayCharsSet_PN = "RWAbcs"        // [int] binary set of this area characteristics


///////////////////////// Area variables ///////////////////////////////////////

const string RW_Area_initiatorTransition_VN = "RWAit";      // [object] reference to the initiator transition body. This reference is valid if, and only if, this area is linked; and the RandomWay in the referenced initiator transition is the one that is using this area. This variable is also useful to know if this area is linked or free.
const string RW_Area_maleTransition_VN = "RWAmt";           // [object] reference to the male transition of this area.
const string RW_Area_femaleTransition_VN = "RWAft";         // [object] reference to the female transition of this area.
const string RW_Area_orientationOffsetCode_VN = "RWAooc";   // [int] tells the offset the magnetic needle. Possible values are: -1 if to reach this area a disorientating transition was traversed; 0 if the magnetic needle tells the true; 1-3 if the magnetic needle it turned this variable value by 90degrees clockwise.
const string RW_Area_isInitialized_VN = "RWAii";            // [boolean] remembers if this area was already initialized
const string RW_Area_noSgeWasSpecified_VN = "RWAnsws";      // [boolean] remembers if this area sge property was specified in the toolset, or set to the random way default.
const string RW_Area_isDungeonEnd_VN = "RWAide";            // [boolean] is TRUE if this is the ending area of a dungeon.
const string RW_Area_isVirgin_VN = "RWTiv";                 // [boolean] set to TRUE on every area when the RandomWay is constructed, and set to FALSE after the 'globalAreaSetupScript' is executed in order to know that the 'globalAreaSetupScript' was already executed. The 'globalAreaSetupScript' is determined by the initiator whose RandomWay instance owns this transition.


///////////////////////// Transition constants /////////////////////////////////

const int RW_IGNORED_CHARS_FOR_MARRIAGE_BETWEEN_DIFFERENT_POOLS = 0xff00; // characteristics corresponding to the bits set in this constante, are ignored when determining marriage compatibility between two propagator transitions which lay in areas of different pools.

// transition type codes
const int RW_Transition_TypeCode_PROPAGATOR = 0;                    //tells that the transition is a propagator. Propagator transitions only lay inside areas that are eligible to compose a random way.
const int RW_Transition_TypeCode_DUNGEON_ENTRANCE = 2;              //tells that the transition is the entrance of a dungeon. The entrance of dungeons is also the initiator of the RandomWay.
const int RW_Transition_TypeCode_DUNGEON_EXIT = 3;                  //tells that the transition is the exit female transition of a dungeon.
const int RW_Transition_TypeCode_SHORTCUT_PRIMARY_ENTRANCE = 4;     //tells that the transition is the primary entrance of a Shorcut. The primary entrance of shortcuts is also the initiator of the RandomWay.
const int RW_Transition_TypeCode_SHORTCUT_SECONDARY_ENTRANCE = 5;   //tells that the transition is the secondary entrance of a Shortcut. The secondary entrance of shortcuts require that the 'primaryEntranceTag' (RWSEpet) property be valid.

const string RW_Initiator_MESSAGE_TO_SEND_WHEN_THE_RANDOMWAY_CONSTRUCTION_WAS_NOT_SUCCESSFUL = "El paso esta bloqueado momentaneamente.";

const string RW_Propagator_TAG_PREFIX = "RW_propag"; // when the RandomWay system is looking for a couple of a transition ('RW_Area_searchMatchingFemale(..)'), it searches for a door or transition trigger whose tag starts with this constant value.

//Sex Resctricion Codes
const int RW_Propagator_Src_MALE_ONLY = 1;
const int RW_Propagator_Src_FEMALE_ONLY = 2;

//Manual Characteristics//
const int RW_Transition_Char_IS_TELEPORTER = 1;             // bit 0
const int RW_Transition_Char_IS_DESCENDING_OR_ASCENDING = 2;// bit 1
const int RW_Transition_Char_IS_ASCENDING = 4;              // bit 2
const int RW_Transition_Char_CAN_BE_DUNGEON_EXIT = 8;       // bit 3

//Automaticaly set Characteristics//
const int RW_Transition_Char_IS_DISORIENTING = 536870912;   // bit 29
const int RW_Transition_Char_IS_ARRIVE_ONLY = 1073741824;   // bit 30


////////////// Transition and specialization properties ////////////////////////
// Transition is the base tramsition type. Initiator, Propagator, and ShortcutSecondaryEntrance, are immediate specializations of Transition. And DungeonEntrance, and ShortcutPrimaryEntrance, are immediate specializations of Initiator.
// Transition and Initiator are abstract. The other are all concrete.

const string RW_DungeonEntrance_poolIndex_PN = "RWDEpi";        // [int] index of the pool from where the areas, that will compose the entire dungeon, are taken from.
const string RW_DungeonEntrance_exitTag_PN = "RWDExt";          // [string] tag of the exit. Only applicable and required in the entrance of dungeons.
const string RW_DungeonExit_poolIndex_PN = "RWDXpi";            // [int] index of the pool whose asociated tileset corresponds to the area where lays the exit female transition. Because exit female transitions (and shortcut secondary entrances) lay on areas that don't belong to any random way pool, it is necesary that, for every tileset T such that a secondary entrance S lays in an area whose tileset is T, exist a pool P whose asociated tileset is T. The largest, but easyer, way to satisfy this, is to have a pool for every tileset used by the module.

const string RW_Initiator_defaultSge_PN = "RWIdsge";            // [string] default SGE script. Used in every area, of the generated random way, that don't have its RS_sge_PN property specified;
const string RW_Initiator_firstAreaCr_PN = "RWIfacr";           // [int] CR of the first dungeon area. If not specified, the default CR is the maximum between 3 and the CR of the base area.
const string RW_Initiator_globalAreaSetupScript_PN = "RWIgass"; // [string] script that is executed the first time a transition T (this initiator included), owned by the RandomWay instance RW asociated with this initiator transition, is clicked since it belongs to RW. OBJECT_SELF will be the couple of the clicked transition T. Useful to do preparations in the area the transition T is target of, that concern to the RandomWay instance RW the transition T is part of. This script is executed before the RW_Area_singularSetupScript_PN that is specified individualy in each area.
const string RW_Initiator_numberOfTripAreas_PN = "RWInta";      // [int] number of trip areas (length) that will have the RandomWay asociated whit this initiator transition.
const string RW_Initiator_poolDescriptorScript_PN = "RWIpds";   // [string] script that is called to obtain the pool descriptor of the pool that will be used to build the random way.
const string RW_Initiator_rebuildPeriodModInMinutes_PN = "RWIrpm"; // [int] by default the rebuild period is one hour. This property modifies this default to: 60minutes + rebuildPeriodModInMinutes

const string RW_Propagator_brotherFilterMask_PN = "RWPbfm";     // [int] together with the 'brotherFilterValue', determines which propagator transitions in the same area than this female transition are eligible to became brother of this female transition. A propagator transition P is eligible to became the brother of this female transition if 'p.binaryCharsSet & this.brotherFilterMask == this.brotherFilterValue'
const string RW_Propagator_brotherFilterValue_PN = "RWPbfv";    // [int] together with the 'brotherFilterMask', determines which propagator transitions in the same area than this female transition are eligible to became brother of this female transition. A propagator transition P is eligible to became the brother of this female transition if 'p.binaryCharsSet & this.brotherFilterMask == this.brotherFilterValue'
const string RW_Propagator_forbidenDestinationPools_PN = "RWPfdp"; // [int] modifies the default (specified by the pool) binay set of pools that this propagator transition permits the destination area belong to.
const string RW_Propagator_innerDeputyTag_PN = "RWPidt";        // [string] when a propagator is not coupled to a propagator in a different area (one as male and the other as female), it can be linked to a inner deputy transition that lays in the same area. This property tells the tag of that inner deputy (or sustitute) transition. The tag of the inner deputy (or sustitute) must not start whith RW_Propagator_TAG_PREFIX, in order to avoid it to be treated as a propagator. The idea is that the inner deputy (or sustitute) lead to a closed room (with no other entrance), such that the uncoupled propagator transitions lead to somewhere, that is more intuitive than than doing nothing.
const string RW_Propagator_permitedDestinationPools_PN = "RWPpdp"; // [int] modifies the default (specified by the pool) binay set of pools that this propagator transition permits the destination area belong to.
const string RW_Propagator_sexRestrictionCode_PN = "RWPsrc";    // [int] limits the possible sexs this proagator transition can behave as: 0->both, 1->male only, 2->female only

const string RW_ShortcutPrimaryEntrance_afterPortalPoolIndex_PN = "RWSPEappi";  // [int] index of the pool from where the areas, that will compose the first part of the shortcut, are taken from: from the primary entrance until the portal inclusive.
const string RW_ShortcutPrimaryEntrance_secondaryEntranceTag_PN = "RWSPEset";   // [string] tag of the secondary entrance transition. Only applicable and required in the primary entrance of shortcuts.
const string RW_ShortcutPrimaryEntrance_untilPortalPoolIndex_PN = "RWSPEuppi";  // [int] index of the pool from where the areas, that will compose the second and last part of the shortcut, are taken from: from the target area of the portal until the last area of the shortcut.

const string RW_ShortcutSecondaryEntrance_primaryEntranceTag_PN = "RWSSEpet";   // [string] tag of the primary entrance transition. Only required in the secondary entrance of shortcuts.
const string RW_ShortcutSecondaryEntrance_poolIndex_PN = "RWSSEpi";             // [int] index of the pool whose asociated tileset corresponds to the area where lays the secondary entrace. Because secondary entrances (and dungeon exit female transitions) lay on areas that don't belong to any random way pool, it is necesary that, for every tileset T such that a secondary entrance S lays in an area whose tileset is T, exist a pool P whose asociated tileset is T. The largest, but easyer, way to satisfy this, is to have a pool for every tileset used by the module.

const string RW_Transition_binaryCharsSet_PN = "RWTbcs";        // [int] binary characteristics set of this transition. The binaryCharsSet is what other transition inspect of this transition to determine if they would like to couple with this transition. This transition is acepted by other transition if:  (this.binaryCharsSet & other.coupleFilterMask) == other.coupleFilterValue
const string RW_Transition_coupleFilterMask_PN = "RWTcfm";      // [int] together with the 'coupleFilterValue', determines which propagator transitions are able to be coupled with this transition. Note that to bind a couple of transitions, both must be able to be binded to the other.
const string RW_Transition_coupleFilterValue_PN = "RWTcfv";     // [int] together with the 'coupleFilterMask', determines which propagator transitions are able to be coupled with this transition. Note that to bind a couple of transitions, both must be able to be binded to the other.
const string RW_Transition_orientationCode_PN = "RWToc";        // [int] Specifies the direction code of this transition. Valid values are: Unoriented->(-1), North->1, East->2, South->3, West->4, Automatic->0 ; 'Unoriented' signals that this transition ignores its fisical orientation, and that can be coupled only with other unoriented transitions (useful for portals); 'Automatic' signals that the orientation code should be obtained from the orientation of the door, or the arrive waypoint.
const string RW_Transition_onTransitScript_PN = "RWTots";       // [string] script that is excecuted every time a PC clicks a coupled transition. If this script is specified, it has the responsability of transfering the PC, that clicked this transition, to the destination. To obtain the PC call 'GetClickingObject()', to obtain the destination call 'RW_Transition_getTargetLocation()', and OBJECT_SELF will be this transition.
const string RW_Transition_typeCode_PN = "RWTtc";               // [int] signals the type of this transition: 0->Propagator, 2->DungeonEntrance, 4->ShortcutPrimaryEntrance, or 5->ShortcutSecondaryEntrance. Propagator transitions don't fetch this property because propagators are discerned by its tag prefix.


///////////// Transition (and their specialization) variables //////////////////
// Transition is the base tramsition type. Initiator, Propagator, and ShortcutSecondaryEntrance, are immediate specializations of Transition. And DungeonEntrance, and ShortcutPrimaryEntrance, are immediate specializations of Initiator.
// Transition and Initiator are abstract. The other are all concrete.

const string RW_DungeonEntrance_exit_VN = "RWDEe"; // [object] reference to the exit transition. Only valid if this transition is the entrance of a dungeon

const string RW_Initiator_randomWayInstance_VN = "RWIrwi"; // [RandomWay] address of the instance of the concrete RandomWay implementation binaryCharsSet. Valid on initiator transitions only.
const string RW_Initiator_expirationDateTime_VN = "RWIedt"; // [int] remembers the date and time when the rebuild expires. The expiration date is set, when the random way is rebuild, to: actualDateTime + 60minutes + rebuildPeriodModInMinutes
const string RW_Initiator_poolIndex_AN = "RWIpi"; //[int] poolIndex argument passed to the pool descriptor script by the RW_Pool_get(..) operation.
const string RW_Initiator_eligibleAreasList_AN = "RWIeal"; // [string] eligibleAreasList argument received from the pool descriptor script to the RW_Pool_get(..) operation.
const string RW_Initiator_defaultPermitedPoolsForDoorsDestination_AN = "RWIdptfdd"; //[int] defaultPermitedPoolsForDoorsDestination argument received from the pool descriptor script to the RW_Pool_get(..) operation.
const string RW_Initiator_defaultPermitedPoolsForOrientedTriggersDestination_AN = "RWIdptfotd";  //[int] defaultPermitedPoolsForOrientedTriggersDestination argument received from the pool descriptor script to the RW_Pool_get(..) operation.
const string RW_Initiator_isRegistered_VN = "RWIir"; // remembers if this initiator was already registered to the PoolsManager
const string RW_Initiator_numConstructionRetries_VN = "RWIncr"; // counts how many sucecive unsuccessful RandomWay constructions has tried this initiator
const string RW_Initiator_wayConstructionWasSuccessful_VN = "RWIwcws"; // Signals if the asociated RandomWay was successfuly constructed. Set to FALSE at the begining of the RandomWay constructor, and must be set to TRUE at the end of the constructor of any extension of RandomWay. Read by the "RW_onTransClick" script to notice if the RandomWay was totaly of partialy constructed.
const string RW_Initiator_totalNominalReward_VN = "RWItnr"; // Every creature killed inside any area that belongs to the last RandomWay instance generated by this initiator; adds, to this variable, the amount of nominal reward given by the creature to all the PC that killed it. So, the value of this variable is proportional all the XP won by PCs in the areas that belong to the actual RandomWay instance. The objetive of this variable is to know how much effort was needed to reach a dungeon end, in order to give a reward proportinal to the effort at the dungeon end.
const string RW_Initiator_consumedNominalReward_VN = "RWIcnr"; // Remembers how much of the 'totalNominalReward' was already given.

const string RW_InnerDoor_outerDoorBody_VN = "RWIDodb"; // [object] reference to the propagator door that represents the outer side of this standard door. This door should be one that is the only entrance to an isolated room placed in the same area than than the outerside door (the uncoupled propagator).

const string RW_Propagator_innerDoorBody_VN = "RWPidb"; // [object] reference to the standard door that represents the inner side of this propagator door when it leads to a closed room because it is not coupled with a propagator door in other area.

const string RW_ShortcutPrimaryEntrance_secondaryEntrance_VN = "RWSPEse"; // [object] reference to the secondary entrance transition. Only valid if this transition is the primary entrance of a shortcut

const string RW_Transition_couple_VN = "RWTc"; // [object] reference to the couple of this transition
const string RW_Transition_arrivePoint_VN = "RWTap"; // [object] remembers the object that determines the arrive point of this transition. The arrive point is the location where the PJs are placed when they came from the couple transition.

const string RW_SecondaryEntrance_primaryEntrance_VN = "RWSEpe"; // [object] reference to the primary entrance transition. Only valid if this transition is a secondary entrance of a shortcut.


//////////////////////////// Pc variables //////////////////////////////////////

const string RW_Pc_previousTransition_VN = "RWpa"; // [object] reference to the last RW_Transition that transfered the user to its couple (which ever lays in other area). Actualized by the handler RW_onTransClick, which is called when a PC fires a trigger onEnter, door onTransitionClick, or placeable onUsed event. The exception is when the last used transition has a special onTransitionScript and it didn't transfer the PC to other area. In this case, this variable remembers the last used transition.
const string RW_PC_hasToIgnoreAreaOnExitEvent_VN = "RWAhtiaoee"; // [boolean] When the RW_Area_onEnter handler notices that the entering object is a PC that is loging in, and the area he is entering into don't belong any more to the RandomWay instance it belonged when the entering PC loged off, the PC is sent to the last entrance he traversed skipping the calls to all the handlers that are subscribed to the areaOnEnter event. Therefore, in order to avoid problems, when this happends, all the handlers subcribed to the areaOnExit event must also be skipped. This variable is the signal the RW_Area_onEnter handler puts in the PC in order to the RW_Area_onExit handlers knows how to behave.

///////////////////////// PoolsManager constants ///////////////////////////////

const string RW_PoolsManager_SINGLETON_TAG = "RWPMsingleton"; // tag of the engine object that holds the PoolManager singleton.


///////////////////////// PoolsManager variables ////////////////////////////////

const string RW_PoolsManager_singleton_VN = "RWPMs"; // [object] reference to the PoolManager singleton
const string RW_PoolsManager_registeredInitiators_VN = "RWPMri"; // [VectorObj] list of all the initiator transitions that were registered by its asociated (and held) RandomWay instance.


///////////////////////////// Reward Chest /////////////////////////////////////

const string RW_ChestWp_TAG = "RW_rewardChestWP"; // When the dungeon end area setup script is the default (RW_Area_singularSetupScript_PN = "rw_area_dedss" ), reward chest are created everywhere a waypont whose tag equals this constant.

const string RW_ChestWp_rewardFraction_PN = "RWCWrf"; // [float=0.34] Tells the fraction of the total reward that will be generated in the asociated container.
const string RW_ChestWp_asociatedPropagatorTag_PN = "RWCWapt"; // [string] the chest will be generated if the the value of this property is empty or equal to the tag of the male propagator of the area.

const string RW_Chest_rewardFraction_VN = "RWCrf"; // [float] Tells the fraction of the total reward that will be generated in this container. This value is initialized by the dungeon end area default setup script with the value obtained from its asociated waypoint.
const string RW_Chest_rwInstanceIdWhenLastOpened_VN = "RWCrwiiwlo"; // [boolean] remembers the identifier of the RandomWay instance this container belongs to the last time it was opened. Actualy, the identifier is the expiration date of the randomWay Instance.

///////////////////////////// Obstacle doors ///////////////////////////////////

const string RW_BashedDoorWp_TAG = "RW_BashedDoorWp"; // tag of the waypoints that are created when the obstacle doors are bashed, in order to remember its position


///////////////////////// Forward declarations /////////////////////////////////

// Searchs in 'thisAreaBody' for a propagator transition that can be coupled with a male transition with the given 'maleProperties'.
// Gives OBJECT_INVALID if no matching transition was found
object RW_Area_searchMatchingFemale( object thisAreaBody, struct RW_Transition_Properties maleProperties, int maleOrientationOffeset, int femaleFilterMask, int femaleFilterValue );

// must be called one, and only one, time for every area before it can be used by the random way.
void RW_Area_initialize( object thisAreaBody, int areaManualCharsSet );


///////////////////////////// Transition Operations ////////////////////////////


int RW_Initiator_getRandomWayInstanceId( object initiatorBody );
int RW_Initiator_getRandomWayInstanceId( object initiatorBody ) {
    return GetLocalInt( initiatorBody, RW_Initiator_expirationDateTime_VN );
}


object RW_Transition_getPrimaryEntrance( object thisTransitionBody );
object RW_Transition_getPrimaryEntrance( object thisTransitionBody ) {
    object primaryEntranceBody = GetLocalObject( thisTransitionBody, RW_SecondaryEntrance_primaryEntrance_VN );
    if( primaryEntranceBody == OBJECT_INVALID ) {
        primaryEntranceBody = GetObjectByTag( GetLocalString( thisTransitionBody, RW_ShortcutSecondaryEntrance_primaryEntranceTag_PN ) );
        if( primaryEntranceBody == OBJECT_INVALID )
            WriteTimestampedLogEntry( "RW_Transition_getPrimaryEntrance: error; areaResRef="+GetResRef(GetArea(thisTransitionBody)) );
        else
            SetLocalObject( thisTransitionBody, RW_SecondaryEntrance_primaryEntrance_VN, primaryEntranceBody );
    }
    return primaryEntranceBody;
}

object RW_Transition_getSecondaryEntrance( object thisTransitionBody );
object RW_Transition_getSecondaryEntrance( object thisTransitionBody ) {
    object secondaryEntranceBody = GetLocalObject( thisTransitionBody, RW_ShortcutPrimaryEntrance_secondaryEntrance_VN );
    if( secondaryEntranceBody == OBJECT_INVALID ) {
        secondaryEntranceBody = GetObjectByTag( GetLocalString( thisTransitionBody, RW_ShortcutPrimaryEntrance_secondaryEntranceTag_PN ) );
        if( secondaryEntranceBody == OBJECT_INVALID )
            WriteTimestampedLogEntry( "RW_Transition_getSecondaryEntrance: error; areaResRef="+GetResRef(GetArea(thisTransitionBody)) );
        else
            SetLocalObject( thisTransitionBody, RW_ShortcutPrimaryEntrance_secondaryEntrance_VN, secondaryEntranceBody );
    }
    return secondaryEntranceBody;
}

object RW_Transition_getExit( object thisTransitionBody );
object RW_Transition_getExit( object thisTransitionBody ) {
    object exitBody = GetLocalObject( thisTransitionBody, RW_DungeonEntrance_exit_VN );
    if( exitBody == OBJECT_INVALID ) {
        string exitTag = GetLocalString( thisTransitionBody, RW_DungeonEntrance_exitTag_PN );
        if( exitTag != "" ) {
            exitBody = GetObjectByTag( exitTag );
            if( exitBody == OBJECT_INVALID )
                WriteTimestampedLogEntry( "RW_Transition_getExit: error; areaResRef="+GetResRef(GetArea(thisTransitionBody)) );
            else
                SetLocalObject( thisTransitionBody, RW_DungeonEntrance_exit_VN, exitBody );
        }
    }
    return exitBody;
}


// The arrive point is the location where the PJs are placed when they came from the couple transition.
object RW_Transition_getArrivePoint( object thisTransitionBody );
object RW_Transition_getArrivePoint( object thisTransitionBody ) {
    object arrivePoint;
    int thisTransitionType = GetObjectType(thisTransitionBody);
    if( thisTransitionType == OBJECT_TYPE_DOOR || thisTransitionType == OBJECT_TYPE_PLACEABLE )
        arrivePoint = thisTransitionBody;
    else if( thisTransitionType = OBJECT_TYPE_TRIGGER ) {
        arrivePoint = GetLocalObject( thisTransitionBody, RW_Transition_arrivePoint_VN );
        if( arrivePoint == OBJECT_INVALID ) {
            arrivePoint = GetTransitionTarget( thisTransitionBody );
            if( arrivePoint == OBJECT_INVALID ) {
                arrivePoint = GetNearestObject( OBJECT_TYPE_WAYPOINT, thisTransitionBody );
                if( arrivePoint == OBJECT_INVALID ) {
                    WriteTimestampedLogEntry( "RW_Transition_getArrivePoint: error, no asociated waypoint was found in area="+GetResRef(GetArea(thisTransitionBody)) );
                    SendMessageToAllDMs( "//Transition error: please tell a module mapper that a transition in the area '"+GetName(GetArea(thisTransitionBody))+"' couln't find its arrivePoint. areaResRef="+GetResRef(GetArea(thisTransitionBody)) );
                    return thisTransitionBody;
                }
            }
            SetLocalObject( thisTransitionBody, RW_Transition_arrivePoint_VN, arrivePoint );
        }
    }
    return arrivePoint;
}


// Gives the orientation code of 'thisTransitionBody': Unoriented->(-1), North->1, East->2, South->3, West->4
int RW_Transition_getOrientationCode( object thisTransitionBody );
int RW_Transition_getOrientationCode( object thisTransitionBody ) {
    int orientationCode = GetLocalInt( thisTransitionBody, RW_Transition_orientationCode_PN );
    if( orientationCode == 0 ) {
        if( (GetLocalInt( thisTransitionBody, RW_Transition_binaryCharsSet_PN ) & RW_Transition_Char_IS_TELEPORTER) != 0 )
            orientationCode = -1;
        else {
            object arrivePoint = RW_Transition_getArrivePoint( thisTransitionBody );
            float facing = GetFacingFromLocation( GetLocation( arrivePoint ) );
            // this expresion converts north->1, east->2, south->3, west->4
            orientationCode = ((FloatToInt(facing+45.0)/90 )%4) + 1;
        }
        SetLocalInt( thisTransitionBody, RW_Transition_orientationCode_PN, orientationCode );
//        SendMessageToPC( GetFirstPC(), "RW_Transition_getOrientationCode: facing="+FloatToString(facing)+", orientationCode="+IntToString(orientationCode) );
    }
    return orientationCode;
}



// Gives the inner deputy transition (in the same area) that represents the other side of this propagator, when it is uncoupled (not coupled with other propagator).
// Asumtions: 'thisDoor' is an uncoupled propagator transition door.
object RW_Propagator_getAndConfigureInnerDeputyTransition( object thisDoor );
object RW_Propagator_getAndConfigureInnerDeputyTransition( object thisDoor ) {
    object innerDoorBody = GetLocalObject( thisDoor, RW_Propagator_innerDoorBody_VN );
    if( innerDoorBody == OBJECT_INVALID ) {
        object area = GetArea( thisDoor );
        string innerTransitionTag = GetLocalString( thisDoor, RW_Propagator_innerDeputyTag_PN );
        object iteratedObject = GetFirstObjectInArea(area);
        while( iteratedObject != OBJECT_INVALID ) {
            if(
                GetTag(iteratedObject) == innerTransitionTag
                && (GetObjectType(iteratedObject) & (OBJECT_TYPE_DOOR|OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_TRIGGER))!=0
            ) {
                innerDoorBody = iteratedObject;
                SetLocalObject( thisDoor, RW_Propagator_innerDoorBody_VN, innerDoorBody );
                SetLocalObject( innerDoorBody, RW_InnerDoor_outerDoorBody_VN, thisDoor );
                break;
            }
            iteratedObject = GetNextObjectInArea(area);
        }
        //SendMessageToPC( GetFirstPC(), "RW_Propagator_getAndConfigureInnerDoor: innerTransitionTag="+innerTransitionTag );
    }
    return innerDoorBody;
}


// initializes 'thisTransition'. Must be called for every transition that was coupled
void RW_Transition_enable( object thisTransitionBody );
void RW_Transition_enable( object thisTransitionBody ) {
    int thisTransitionType = GetObjectType(thisTransitionBody);
    if( thisTransitionType == OBJECT_TYPE_PLACEABLE ) {
        SetUseableFlag( thisTransitionBody, TRUE );
        SetPlaceableIllumination( thisTransitionBody, TRUE );
        //AssignCommand( thisTransitionBody, PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE ) );
    }
    else if( thisTransitionType == OBJECT_TYPE_TRIGGER && GetIsTrapped( thisTransitionBody ) ) {
        SetTrapActive( thisTransitionBody, TRUE );
        SetTrapDetectable( thisTransitionBody, TRUE );
        SetTrapDetectDC( thisTransitionBody, 0 );
        SetTrapDisarmable( thisTransitionBody, FALSE );
        SetTrapOneShot( thisTransitionBody, FALSE );
    }
}

// makes not usable the uncoupled transitions implemented with placeables, and diables the uncoupled transitions implemented with triggers of type "trap".
void RW_Transition_disable( object thisTransitionBody );
void RW_Transition_disable( object thisTransitionBody ) {
    int thisTransitionBodyType = GetObjectType( thisTransitionBody );
    // make propagator transitions implemented with placeables not useable
    if( thisTransitionBodyType == OBJECT_TYPE_PLACEABLE ) {
        SetUseableFlag( thisTransitionBody, FALSE );
        SetPlaceableIllumination( thisTransitionBody, FALSE );
        //AssignCommand( thisTransition, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
    }
    // hide and disable propagator transitions implemented with trap triggers that don't have an asociated inner corridoor
    else if(
        thisTransitionBodyType == OBJECT_TYPE_TRIGGER
        && GetIsTrapped(thisTransitionBody)
        && GetLocalString( thisTransitionBody, RW_Propagator_innerDeputyTag_PN ) == ""
    ) {
        // if the trap is active, change its state to not visible by any PC
        if( GetTrapActive(thisTransitionBody) ) {
            object iteratedPc = GetFirstPC();
            while( iteratedPc != OBJECT_INVALID ) {
                SetTrapDetectedBy( thisTransitionBody, iteratedPc, FALSE );
                iteratedPc = GetNextPC();
            }
        }
        SetTrapDetectable( thisTransitionBody, FALSE );
        SetTrapActive( thisTransitionBody, FALSE );
    }
}


struct RW_Transition_Properties {
    int orientationCode;
    int bodyType;
    int binaryCharsSet;
    int coupleFilterMask;
    int coupleFilterValue;
};


struct RW_Transition_Properties RW_Transition_getProperties( object thisTransitionBody );
struct RW_Transition_Properties RW_Transition_getProperties( object thisTransitionBody ) {
    struct RW_Transition_Properties properties;
    properties.orientationCode = RW_Transition_getOrientationCode( thisTransitionBody );
    properties.bodyType = GetObjectType( thisTransitionBody );
    properties.binaryCharsSet = GetLocalInt( thisTransitionBody, RW_Transition_binaryCharsSet_PN );
    properties.coupleFilterMask = GetLocalInt( thisTransitionBody, RW_Transition_coupleFilterMask_PN );
    properties.coupleFilterValue = GetLocalInt( thisTransitionBody, RW_Transition_coupleFilterValue_PN );
    return properties;
}


int RW_Transition_areCompatible( struct RW_Transition_Properties maleProperties, struct RW_Transition_Properties femaleProperties, int maleOrientationOffsetCode );
int RW_Transition_areCompatible( struct RW_Transition_Properties maleProperties, struct RW_Transition_Properties femaleProperties, int maleOrientationOffsetCode ) {
    int result = FALSE;
    if(
        (   maleProperties.bodyType == femaleProperties.bodyType
            || (
                maleProperties.bodyType != OBJECT_TYPE_DOOR
                && femaleProperties.bodyType != OBJECT_TYPE_DOOR
                && maleProperties.orientationCode < 0
                && femaleProperties.orientationCode < 0
            )
        )
        && (maleProperties.binaryCharsSet & femaleProperties.coupleFilterMask) == femaleProperties.coupleFilterValue
        && (femaleProperties.binaryCharsSet & maleProperties.coupleFilterMask) == maleProperties.coupleFilterValue
    ) {
        if( maleProperties.orientationCode < 0 && femaleProperties.orientationCode < 0 )
            result = TRUE;
        else if( maleProperties.orientationCode > 0 && femaleProperties.orientationCode > 0 ) {
            if( maleOrientationOffsetCode < 0 )
                result = TRUE;
            else {
                int difference = 6 + maleProperties.orientationCode + maleOrientationOffsetCode - femaleProperties.orientationCode;
                if( difference%4 == 0 )
                    result = TRUE;
            }
        }
    }
    if( RW_debug ) WriteTimestampedLogEntry( "RW_Transition_areCompatible: areCompatible="+IntToString(result)+", bodyType="+IntToString(maleProperties.bodyType)+"<->"+IntToString(femaleProperties.bodyType)+", orientationCode="+IntToString(maleProperties.orientationCode)+"<->"+IntToString(femaleProperties.orientationCode)+", binaryCharsSet="+IntToString(maleProperties.binaryCharsSet)+"<->"+IntToString(femaleProperties.binaryCharsSet)+", coupleFilterMask="+IntToString(maleProperties.coupleFilterMask)+"<->"+IntToString(femaleProperties.coupleFilterMask)+", coupleFilterValue="+IntToString(maleProperties.coupleFilterValue)+"<->"+IntToString(femaleProperties.coupleFilterValue) );
    return result;
}


const int RW_Ccst_AREA_TAG_WIDTH = 32;
const int RW_Ccst_AREA_CHARS_SET_OFFSET = 32;
const int RW_Ccst_AREA_CHARS_SET_WIDTH = 4;
const int RW_Ccst_ELEMENT_LENGTH = 40; // "<32 for area tag><4 for categories>,<3 for weight>"

// Chooses a free (not already linked) area 'A' from the ones contained in 'eligibleAreasWS' such that 'A' contains a propagator transition 'P' that can be coupled with 'thisTransitionBody'.
// Gives 'P' if 'A' and 'P' are found. Note that 'P' will become the wife of 'thisTransitionBody'.
// Gives OBJECT_INVALID if none of the free areas in 'eligibleAreasWSDescriptor' contains a transition that can be coupled with 'thisTransitionBody'.
// Asumption: 'thisTransitionBody' is not already bound (has a couple)
object RW_Transition_seekWife( object thisTransitionBody, struct WeightedSelector eligibleAreasWS, int areaFilterMask, int areaFilterValue, int wifeFilterMask, int wifeFilterValue );
object RW_Transition_seekWife( object thisTransitionBody, struct WeightedSelector eligibleAreasWS, int areaFilterMask, int areaFilterValue, int wifeFilterMask, int wifeFilterValue ) {
    struct RW_Transition_Properties maleProperties = RW_Transition_getProperties( thisTransitionBody );
    int maleOrientationOffsetCode = GetLocalInt( GetArea(thisTransitionBody), RW_Area_orientationOffsetCode_VN );

    if( RW_debug ) WriteTimestampedLogEntry( "RW_Transition_seekWife: areaFilterMask="+IntToString(areaFilterMask)+", areaFilterValue="+IntToString(areaFilterValue) );

    while( eligibleAreasWS.totalWeight > 0 ) {
        string choseField = WeightedSelector_choose(eligibleAreasWS);

        int chosenAreaCharsSet = StringToInt( GetSubString( choseField, RW_Ccst_AREA_CHARS_SET_OFFSET, RW_Ccst_AREA_CHARS_SET_WIDTH ) );
        if( RW_debug ) WriteTimestampedLogEntry( "RW_Transition_seekWife: chosenAreaCharsSet=["+IntToString(chosenAreaCharsSet)+"]" );
        if( (chosenAreaCharsSet & areaFilterMask) == areaFilterValue ) {

            // get area tag and remove trailing spaces
            int trimIndex = FindSubString( choseField, " " );
            if( trimIndex < 0 )
                trimIndex = RW_Ccst_AREA_TAG_WIDTH;
            string chosenAreaTag = GetStringLeft( choseField, trimIndex );

            object chosenAreaBody = GetObjectByTag( chosenAreaTag );
            if( RW_debug ) WriteTimestampedLogEntry( "RW_Transition_seekWife: chosenAreaTag=["+chosenAreaTag+"]" );
            if( !GetIsObjectValid( chosenAreaBody ) )
                WriteTimestampedLogEntry( "RW_Transition_seekWife: error, destinationTag="+chosenAreaTag+", transitionTag="+GetTag(thisTransitionBody)+", transitionAreaTag="+GetTag(GetArea(thisTransitionBody)) );

            // if 'choseAreaBody' is not already linked
            else if( GetLocalObject( chosenAreaBody, RW_Area_initiatorTransition_VN ) == OBJECT_INVALID ) {

                // if the 'chosenAreaBody' was not initialized, do it now
                if( !GetLocalInt( chosenAreaBody, RW_Area_isInitialized_VN ) )
                    RW_Area_initialize( chosenAreaBody, chosenAreaCharsSet );

                // search a matching female for 'thisTransitionBody'
                object femaleTransitionBody = RW_Area_searchMatchingFemale( chosenAreaBody, maleProperties, maleOrientationOffsetCode, wifeFilterMask, wifeFilterValue );
                if( femaleTransitionBody != OBJECT_INVALID ) {
                    return femaleTransitionBody;
                }
            }
        }
        eligibleAreasWS = WeightedSelector_remove( eligibleAreasWS, choseField );
    }
    WriteTimestampedLogEntry( "RW_Transition_seekWife: warning, no wife was found, perhaps because the areas pool is empty. areaResRef="+GetResRef(GetArea(thisTransitionBody)) );
    return OBJECT_INVALID;
}


////////////////////////// Area Operations /////////////////////////////////////

// tells if 'thisAreaBody' is such that its orientation is noticeable. Exterior areas are oriented by default.
// When an area is oriented, it is not able to be rotated: its 'areaOrientationOffsetCode' must be cero.
int RW_Area_isOriented( object thisAreaBody );
int RW_Area_isOriented( object thisAreaBody ) {
    return
        GetLocalInt( thisAreaBody, RW_Area_isOriented_PN )
        || !GetIsAreaInterior(thisAreaBody) && !GetLocalInt( thisAreaBody, RW_Area_isUnoriented_PN )
    ;
}


void RW_Area_initialize( object thisAreaBody, int areaManualCharsSet ) {
    SetLocalInt( thisAreaBody, RW_Area_isInitialized_VN, TRUE );

    int areaDetectedCharsSet = 0;
    object iteratedObject = GetFirstObjectInArea( thisAreaBody );
    while( iteratedObject != OBJECT_INVALID ) {
        if( FindSubString( GetTag( iteratedObject ), RW_Propagator_TAG_PREFIX ) == 0 ) {
            struct RW_Transition_Properties properties = RW_Transition_getProperties( iteratedObject );

            if( (properties.binaryCharsSet & RW_Transition_Char_IS_TELEPORTER) != 0 )
                areaDetectedCharsSet |= RW_Area_Char_HAS_A_TELEPORTER;

            if( properties.orientationCode < 0 )
                properties.binaryCharsSet |= RW_Transition_Char_IS_DISORIENTING;
            if( properties.bodyType == OBJECT_TYPE_PLACEABLE && !GetUseableFlag(iteratedObject) ) {
                properties.binaryCharsSet |= RW_Transition_Char_IS_ARRIVE_ONLY;
                //SetLocalInt( iteratedObject, RW_Propagator_sexRestrictionCode_PN, RW_Propagator_Src_FEMALE_ONLY | GetLocalInt( iteratedObject, RW_Propagator_sexRestrictionCode_PN ) );
            }

            SetLocalInt( iteratedObject, RW_Transition_binaryCharsSet_PN, properties.binaryCharsSet );
        }
        iteratedObject = GetNextObjectInArea( thisAreaBody );
    }

    if( (areaDetectedCharsSet & RW_Area_Char_HAS_A_TELEPORTER) != (areaManualCharsSet & RW_Area_Char_HAS_A_TELEPORTER) )
        WriteTimestampedLogEntry( "RW_Area_initialize: error, difference between the detected and manualy set characteristics of the area whose tag is "+GetTag(thisAreaBody) );
}


void RW_Area_hideAllPropagatorTriggersAndCloseAllDoors( object thisAreaBody );
void RW_Area_hideAllPropagatorTriggersAndCloseAllDoors( object thisAreaBody ) {
    object iteratedObject = GetFirstObjectInArea(thisAreaBody);
    while( iteratedObject != OBJECT_INVALID ) {
        // close and heal doors
        if( GetObjectType(iteratedObject) == OBJECT_TYPE_DOOR ) {

            //the is apparently not necesary because the doors are healed during the RandomWay construction by the constructor of every RandomWay concrete implementations (Shortcut and Dungeon), when the SPC_Placeable_montarObstaculo(..) is called. But, if this line is not present here, the door can be traspased like a ghost.
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( GetMaxHitPoints(iteratedObject) ), iteratedObject );

            if( GetIsOpen(iteratedObject) )
                ActionCloseDoor( iteratedObject );
        }
        if( FindSubString( GetTag(iteratedObject), RW_Propagator_TAG_PREFIX ) == 0 )
            RW_Transition_disable( iteratedObject );

        iteratedObject = GetNextObjectInArea(thisAreaBody);
    }
}


//see declaration
object RW_Area_searchMatchingFemale( object thisAreaBody, struct RW_Transition_Properties maleProperties, int maleOrientationOffeset, int femaleFilterMask, int femaleFilterValue ) {
    if( RW_debug ) WriteTimestampedLogEntry( "RW_Area_searchMatchingFemale: recibedTransition - bodyType="+IntToString(maleProperties.bodyType)+", orientationCode="+IntToString(maleProperties.orientationCode)+", binaryCharsSet="+IntToString(maleProperties.binaryCharsSet)+", coupleFilterMask="+IntToString(maleProperties.coupleFilterMask)+", coupleFilterValue="+IntToString(maleProperties.coupleFilterValue)+", femaleFilterMask="+IntToString(femaleFilterMask)+", femaleFilterValue="+IntToString(femaleFilterValue) );
    if( !RW_Area_isOriented( thisAreaBody ) )
        maleOrientationOffeset = -1;

    int numPossibleFemales = 0;
    object iteratedObject = GetFirstObjectInArea( thisAreaBody );
    while( iteratedObject != OBJECT_INVALID ) {
        if(
            FindSubString( GetTag( iteratedObject ), RW_Propagator_TAG_PREFIX ) == 0
            && GetLocalInt( iteratedObject, RW_Propagator_sexRestrictionCode_PN ) != RW_Propagator_Src_MALE_ONLY
            && (GetLocalInt( iteratedObject, RW_Transition_binaryCharsSet_PN ) & femaleFilterMask) == femaleFilterValue
        ) {
            struct RW_Transition_Properties femaleProperties = RW_Transition_getProperties( iteratedObject );
            if( RW_Transition_areCompatible( maleProperties, femaleProperties, maleOrientationOffeset ) )
                numPossibleFemales += 1;
        }
        if( RW_debug ) WriteTimestampedLogEntry( "RW_Area_searchMatchingFemale: iteratedObject="+GetTag(iteratedObject)+", numPossibleFemales="+IntToString(numPossibleFemales) );
        iteratedObject = GetNextObjectInArea( thisAreaBody );
    }
    if( numPossibleFemales == 0 )
        return OBJECT_INVALID;  // this happends when no matching transition was found

    int choseIndex = Random( numPossibleFemales );
    if( RW_debug ) WriteTimestampedLogEntry( "RW_Area_searchMatchingFemale: choseIndex="+IntToString(choseIndex) );
    iteratedObject = GetFirstObjectInArea( thisAreaBody );
    while( TRUE ) {
        if(
            FindSubString( GetTag( iteratedObject ), RW_Propagator_TAG_PREFIX ) == 0
            && GetLocalInt( iteratedObject, RW_Propagator_sexRestrictionCode_PN ) != RW_Propagator_Src_MALE_ONLY
            && (GetLocalInt( iteratedObject, RW_Transition_binaryCharsSet_PN ) & femaleFilterMask) == femaleFilterValue
        ) {
            struct RW_Transition_Properties femaleProperties = RW_Transition_getProperties( iteratedObject );
            if( RW_Transition_areCompatible( maleProperties, femaleProperties, maleOrientationOffeset ) && --choseIndex < 0 ) {
                int thisAreOrientationOffesetCode = maleOrientationOffeset;
                if( thisAreOrientationOffesetCode >= 0 ) {
                    thisAreOrientationOffesetCode += 6 + femaleProperties.orientationCode - maleProperties.orientationCode;
                    thisAreOrientationOffesetCode %= 4;
                }
                SetLocalInt( thisAreaBody, RW_Area_orientationOffsetCode_VN, thisAreOrientationOffesetCode );
                return iteratedObject;
            }
        }
        iteratedObject = GetNextObjectInArea( thisAreaBody );
    }

    return OBJECT_INVALID; // this line is never reached, but is needed to avoid compiler errors.
}


// privately and internaly used by 'RW_Area_seekBrotherOf(..)' only
struct RW_BrotherRequisites {
    int filterMask; // the chosen propagator transition must pass the filter requirement established by the female transition of the searched area
    int filterValue;
    int targetAreaPoolCode; // the chosen propagator transition must be able to target an area whose pool code equals this field value
    int defaultPermitedPoolsForDoorsDestination; // binary set of destination pools that are permited by the departure pool, when the transition is a door
    int defaultPermitedPoolsForOrientedTriggersDestination; // binary set of destination pools that are permited by the departure pool, when the transition is an oriented trigger
    object futureWifeBody; // the chosen propagator transition must be able to get married with the transition specified by this field
    int areaOrientationOffsetCode; // orientation offset of the searched area
};


// privately and internaly used by 'RW_Area_seekBrotherOf(..)' only
// Gives TRUE if 'this' propagator transition is eligible to become a brother (and, therefore, a male).
int RW_Transition_isEligibleToBecomeBrother( object this, struct RW_BrotherRequisites br, struct RW_Transition_Properties futureWifeProperties );
int RW_Transition_isEligibleToBecomeBrother( object this, struct RW_BrotherRequisites br, struct RW_Transition_Properties futureWifeProperties ) {
    if(
        GetLocalInt( this, RW_Propagator_sexRestrictionCode_PN ) != RW_Propagator_Src_FEMALE_ONLY
        && (GetLocalInt( this, RW_Transition_binaryCharsSet_PN ) & br.filterMask) == br.filterValue
        && (
            br.futureWifeBody==OBJECT_INVALID
            || RW_Transition_areCompatible( RW_Transition_getProperties(this), futureWifeProperties, br.areaOrientationOffsetCode )
        )
    ) {
        int thisTransitionPermitedDestinationPools = GetLocalInt( this, RW_Propagator_permitedDestinationPools_PN );
        int thisType = GetObjectType(this);
        if( thisType == OBJECT_TYPE_DOOR )
            thisTransitionPermitedDestinationPools |= br.defaultPermitedPoolsForDoorsDestination;
        else if( thisType == OBJECT_TYPE_TRIGGER && RW_Transition_getOrientationCode(this) > 0 )
            thisTransitionPermitedDestinationPools |= br.defaultPermitedPoolsForOrientedTriggersDestination;
        else // if the iterated propagator transition is a placeable or an unoriented trigger, permit, by default, any pool for the target area
            thisTransitionPermitedDestinationPools = -1;

        if( (thisTransitionPermitedDestinationPools & br.targetAreaPoolCode & ~GetLocalInt( this, RW_Propagator_forbidenDestinationPools_PN )) != 0 )
            return TRUE;
    }
    return FALSE;
}


// Given 'S', the set of all propagator transitions 'P' that satisfy the requirements to be the brother of 'sisterBody', gives one 'P' of 'S' chosen randomly.
// Parameters:
// - object thisAreaBody: area where the search will take place
// - int extraFilterMask and extraFilterValue: // establishe characteristics requirements for 'P', that are added to the requirements of 'sisterBody'.
// - object sisterBody,  // the only already coupled propagator transitionthe in 'thisAreaBody', and for which this operation tries to find a brother.
// - int nextAreaPoolIndex, // the chosen propagator transition must be able to target an area whose pool index is the specified by this parameter. Note that poolCode == 1<<(poolIndex-1)
// - int defaultPermitedPoolsForDoorsDestination, // binary set of destination pools that are permited by the departure pool (the pool of 'thisAreaBody'), when the transition is a door
// - int defaultPermitedPoolsForOrientedTriggersDestination, // binary set of destination pools that are permited by the departure pool (the pool of 'thisAreaBody'), when the transition is an oriented trigger
// - object sisterInLawBody // if specified, the chosen propagator transition must be able to be coupled with she.
// Assumptions:
//  - 'nextAreaPoolIndex != 0'
//  - if 'sisterInLawBody!=OBJECT_INVALID', the pool code of area where lays 'sisterInLawBody' must be equal to 'nextAreaPoolCode'
object RW_Area_seekBrotherOf( object thisAreaBody, int extraFilterMask, int extraFilterValue, object sisterBody, int defaultPermitedPoolsForDoorsDestination, int defaultPermitedPoolsForOrientedTriggersDestination, object sisterInLawBody, int nextAreaPoolIndex );
object RW_Area_seekBrotherOf( object thisAreaBody, int extraFilterMask, int extraFilterValue, object sisterBody, int defaultPermitedPoolsForDoorsDestination, int defaultPermitedPoolsForOrientedTriggersDestination, object sisterInLawBody, int nextAreaPoolIndex ) {
    struct RW_BrotherRequisites br;
    br.filterMask = GetLocalInt( sisterBody, RW_Propagator_brotherFilterMask_PN );
    br.filterValue = GetLocalInt( sisterBody, RW_Propagator_brotherFilterValue_PN );
    // if the filter established by the sister (the wife of this area) and the filter established by the caller are in conflict (impossible to satisfy both), OBJECT_INVALID is returned.
    int commonBits = br.filterMask & extraFilterMask;
    if( (extraFilterValue & commonBits) != (br.filterValue & commonBits) )
        return OBJECT_INVALID;
    // else, mergue both filters
    br.filterMask |= extraFilterMask;
    br.filterValue |= extraFilterValue;

    br.targetAreaPoolCode = 1 << (nextAreaPoolIndex-1);
    br.defaultPermitedPoolsForDoorsDestination = defaultPermitedPoolsForDoorsDestination;
    br.defaultPermitedPoolsForOrientedTriggersDestination = defaultPermitedPoolsForOrientedTriggersDestination;
    br.futureWifeBody = sisterInLawBody;

    struct RW_Transition_Properties sisterInLawProperties;
    if( br.futureWifeBody != OBJECT_INVALID ) {
        sisterInLawProperties = RW_Transition_getProperties( sisterInLawBody );
        br.areaOrientationOffsetCode = GetLocalInt( thisAreaBody, RW_Area_orientationOffsetCode_VN );
        if( !RW_Area_isOriented( GetArea( sisterInLawBody ) ) )
            br.areaOrientationOffsetCode = -1;
    }

    if( RW_debug ) WriteTimestampedLogEntry( "RW_Area_seekBrotherOf: brotherFilterMask="+IntToString(br.filterMask)+", brotherFilterValue="+IntToString(br.filterValue) );

    int numPossibleBrothers = 0;
    object iteratedObject = GetFirstObjectInArea( thisAreaBody );
    while( iteratedObject != OBJECT_INVALID ) {
        if( // IMPORTAN: this if condition must be exactly the same as the if condition inside the next loop
            iteratedObject != sisterBody
            && FindSubString( GetTag( iteratedObject ), RW_Propagator_TAG_PREFIX ) == 0
        ) {
            if( RW_Transition_isEligibleToBecomeBrother( iteratedObject, br, sisterInLawProperties ) )
                numPossibleBrothers += 1;

            RW_Transition_disable(iteratedObject);
        }
        if( RW_debug ) WriteTimestampedLogEntry( "RW_Area_seekBrotherOf: iteratedObject="+GetTag(iteratedObject)+", iteratedObjectBinaryCharsSet="+IntToString(GetLocalInt( iteratedObject, RW_Transition_binaryCharsSet_PN ))+", numPossibleBrothers="+IntToString(numPossibleBrothers) );
        iteratedObject = GetNextObjectInArea( thisAreaBody );
    }
    if( numPossibleBrothers == 0 )
        return OBJECT_INVALID;

    int choseIndex = Random( numPossibleBrothers );
    if( RW_debug ) WriteTimestampedLogEntry( "RW_Area_seekBrotherOf: choseIndex="+IntToString(choseIndex) );
    iteratedObject = GetFirstObjectInArea( thisAreaBody );
    do {
        if( // IMPORTAN: this if condition must be exactly the same as the if condition inside the previous loop
            iteratedObject != sisterBody
            && FindSubString( GetTag( iteratedObject ), RW_Propagator_TAG_PREFIX ) == 0
            && RW_Transition_isEligibleToBecomeBrother( iteratedObject, br, sisterInLawProperties )
        )
            if( --choseIndex < 0 ) {
                if( RW_debug ) WriteTimestampedLogEntry( "RW_Area_seekBrotherOf: chosenBrother="+GetTag(iteratedObject) );
                return iteratedObject;
            }
        iteratedObject = GetNextObjectInArea( thisAreaBody );
    } while( TRUE );

    return OBJECT_INVALID; // this line is never reached, but is needed to avoid compiler errors.
}


////////////////////////////// Pool operations /////////////////////////////////

struct RW_Pool {
    int code;
    int defaultPermitedPoolsForDoorsDestination; // binary set of destination pools that are permited by the departure pool, when the transition is a door
    int defaultPermitedPoolsForOrientedTriggersDestination; // binary set of destination pools that are permited by the departure pool, when the transition is an oriented trigger
    string eligibleAreasWsArray;
    int eligibleAreasWsElementLength;
    int eligibleAreasWsTotalWeight;
};


struct RW_Pool RW_Pool_get( object initiatorBody, int poolIndex );
struct RW_Pool RW_Pool_get( object initiatorBody, int poolIndex ) {
    struct RW_Pool pool;
    pool.code = 1 << (poolIndex-1);

    SetLocalInt( initiatorBody, RW_Initiator_poolIndex_AN, poolIndex );
    string poolDescriptorScript = GetLocalString( initiatorBody, RW_Initiator_poolDescriptorScript_PN );
    if( GetStringLength(poolDescriptorScript) == 0 )
        poolDescriptorScript = "RW_PM_defPDS";
    ExecuteScript( poolDescriptorScript, initiatorBody );

    pool.defaultPermitedPoolsForDoorsDestination = GetLocalInt( initiatorBody, RW_Initiator_defaultPermitedPoolsForDoorsDestination_AN );
    pool.defaultPermitedPoolsForOrientedTriggersDestination = GetLocalInt( initiatorBody, RW_Initiator_defaultPermitedPoolsForOrientedTriggersDestination_AN );

    struct WeightedSelector eligibleAreasWs = WeightedSelector_create( GetLocalString( initiatorBody, RW_Initiator_eligibleAreasList_AN ), RW_Ccst_ELEMENT_LENGTH );
    pool.eligibleAreasWsArray = eligibleAreasWs.array;
    pool.eligibleAreasWsElementLength = eligibleAreasWs.elementLength;
    pool.eligibleAreasWsTotalWeight = eligibleAreasWs.totalWeight;

    // delete all the variables used to give script arguments, and receive script results
    DeleteLocalInt( initiatorBody, RW_Initiator_poolIndex_AN );
    DeleteLocalString( initiatorBody, RW_Initiator_eligibleAreasList_AN );
    DeleteLocalInt( initiatorBody, RW_Initiator_defaultPermitedPoolsForDoorsDestination_AN );
    DeleteLocalInt( initiatorBody, RW_Initiator_defaultPermitedPoolsForOrientedTriggersDestination_AN );
    return pool;
}


struct WeightedSelector RW_Pool_getEligibleAreasWs( struct RW_Pool thisPool );
struct WeightedSelector RW_Pool_getEligibleAreasWs( struct RW_Pool thisPool ) {
    struct WeightedSelector eligibleAreasWs;
    eligibleAreasWs.array = thisPool.eligibleAreasWsArray;
    eligibleAreasWs.elementLength = thisPool.eligibleAreasWsElementLength;
    eligibleAreasWs.totalWeight = thisPool.eligibleAreasWsTotalWeight;
    return eligibleAreasWs;
}


//////////////////////////// PoolsManager //////////////////////////////////////

object RW_PoolsManager_getSingleton();
object RW_PoolsManager_getSingleton() {
    object singleton = GetLocalObject( GetModule(), RW_PoolsManager_singleton_VN );
    // if the singleton was not already constructed, build it.
    if( singleton == OBJECT_INVALID ) {
        singleton = GetObjectByTag( RW_PoolsManager_SINGLETON_TAG );
        if( singleton == OBJECT_INVALID ) {
            WriteTimestampedLogEntry( "RW_PoolsManager_getSingleton: error 1" );
            return OBJECT_INVALID;
        }
        SetLocalObject( GetModule(), RW_PoolsManager_singleton_VN, singleton );

        struct Address registeredInitiators = Address_create( singleton, RW_PoolsManager_registeredInitiators_VN );
        VectorObj_constructor( registeredInitiators );
    }
    return singleton;
}


// Every RW_RandomWay instance must call this operation one, and only one, time to register its asociated initiator transition.
void RW_PoolsManager_register( object this, object initiator );
void RW_PoolsManager_register( object this, object initiator ) {
    struct Address registeredInitiators = Address_create( this, RW_PoolsManager_registeredInitiators_VN );
    VectorObj_pushBack( registeredInitiators, initiator );
}

