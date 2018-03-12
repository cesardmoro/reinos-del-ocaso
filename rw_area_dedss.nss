/************** RandomWay Area dungeon end default setup script ****************
Autor: Inquisidor
Description: The RandomWay system has an area property called 'RW_Area_singularSetupScript_PN' (="RWAsss") which,
when the name of a script S is set, S is is executed the first time any of the transitions, that are coupled
to a propagator transition of this area, is clicked. OBJECT_SELF will be the couple C of the clicked transition.
Note that C lays in this area. Useful to do preparations that are specific to this area.
This script is executed after the area setup script that is specified with RW_Initiator_globalAreaSetupScript_PN
in the initiator transition that constructed the RandomWay instance this area belongs to.

This script, in particular, was made to be put in the RW_Area_singularSetupScript_PN property, in order to generate
the treasure for the final area of a RandomWay dungeon.
If the area where this script is executed is a RandomWay dungeon final area, the treasure is placed in chests over
the reward chests waypoints that are asociated with the propagator transition which was chosen to be the male
transition of the area. See 'RW_facade_inc' for details.
*******************************************************************************/
#include "SPC_Cofre_inc"


void createChest( object chestWaypoint, int areaCr ) {
    object chestBody = SPC_CofreWP_getCofre( chestWaypoint );

    // empty the chest
    object iteratedItem = GetFirstItemInInventory(chestBody);
    while( iteratedItem != OBJECT_INVALID ) {
        DestroyObject( iteratedItem );
        iteratedItem = GetNextItemInInventory(chestBody);
    }

    // set the reward fraction
    float rewardFraction = GetLocalFloat( chestWaypoint, RW_ChestWp_rewardFraction_PN );
    if( rewardFraction == 0.0 )
        rewardFraction = 0.34;
    SetLocalFloat( chestBody, RW_Chest_rewardFraction_VN, rewardFraction );

    // mount a lock and a trap
    SPC_Placeable_montarObstaculo( chestBody, areaCr, 1, 1 );

    // Note that the reward is created when the chest is opened in order to consider the reward corresponding to the creatures killed in this area (the dungeon end).

//    SendMessageToPC( GetFirstPC(), "RW_Area_DEDSS: cofre creado="+GetName(chestBody) );
}


void main() {
//    SendMessageToPC( GetFirstPC(), "RW_Area_DEDSS: begin" );

    object arriveTransitionBody = OBJECT_SELF;
    object areaBody = GetArea( arriveTransitionBody );

    if( GetLocalInt( areaBody, RW_Area_isDungeonEnd_VN ) ) {
        object malePropagatorBody = GetLocalObject( areaBody, RW_Area_maleTransition_VN );
        string malePropagatorTag = GetTag( malePropagatorBody );

        int areaCr = GetLocalInt( areaBody, RS_crArea_PN );

        // create treasure chest on the waypoints asociated with the male propagator. If the dungeon has an exit, the male propagator is the exiting transition.
        object iteratedObject = GetFirstObjectInArea( areaBody );
        while( iteratedObject != OBJECT_INVALID ) {
//            SendMessageToPC( GetFirstPC(), "RW_Area_DEDSS: iteratedObject="+GetTag(iteratedObject) );
            if(
                GetObjectType(iteratedObject) == OBJECT_TYPE_WAYPOINT
                && GetTag(iteratedObject) == RW_ChestWp_TAG
            ) {
                string asociatedPropagatorTag = GetLocalString( iteratedObject, RW_ChestWp_asociatedPropagatorTag_PN );
                if( GetStringLength(asociatedPropagatorTag)==0 || asociatedPropagatorTag == malePropagatorTag )
                    AssignCommand( areaBody, createChest( iteratedObject, areaCr ) ); // the assign command is necesary, because the GetNextObjectInArea(..) don't works if a new object is created in the area it iterates. Note that waypoints can't be used as action subjects.
            }
            iteratedObject = GetNextObjectInArea( areaBody );
        }
    }

//    SendMessageToPC( GetFirstPC(), "RW_Area_DEDSS: end" );
}
