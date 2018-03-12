/*************** RandomWay - area onEnter event handler  ***********************
Package: RandomWay - area onEnter event handler
Author: Inquisidor
*******************************************************************************/
#include "RW_facade_inc"
#include "Mod_inc"

void main() {
//    SendMessageToPC( GetFirstPC(), "RW_Area_onEnter: begin" );

    object thisAreaBody = OBJECT_SELF;
    object enteringObject = GetEnteringObject();

    if(
        GetIsPC(enteringObject)
        && !GetIsDM(enteringObject)
        && !GetIsDMPossessed(enteringObject)
        && GetLocalInt( enteringObject, Mod_ON_PC_ENTERS_WORLD_LATCH )
    ) {
        // si el área es independiente, y no esta contenida por la misma instancia del random way (mismo iniciador y random way construido al mismo tiempo que lo que registra el PJ), enviar el PJ al iniciador registrado en el PJ.
        object initiatorBody = GetLocalObject( thisAreaBody, RW_Area_initiatorTransition_VN );
        int rwInstanceIdOfTheLastTraversedEntrance = GetCampaignInt( RW_Pc_lastTraversedEntrance_DB, RW_Pc_rwInstanceIdOfTheLastTraversedEntrance_VN, enteringObject );
//        SendMessageToPC( GetFirstPC(), "RW_Area_onEnter: initiatorBody="+GetName(initiatorBody)+", rwInstanceIdOfTheLastTraversedEntrance="+IntToString(rwInstanceIdOfTheLastTraversedEntrance) );
        if(
            !GetIsObjectValid( initiatorBody )
            || rwInstanceIdOfTheLastTraversedEntrance != RW_Initiator_getRandomWayInstanceId( initiatorBody )
        ) {
            string lastTraversedEntranceTag = GetCampaignString( RW_Pc_lastTraversedEntrance_DB, RW_Pc_lastTraversedEntranceTag_VN, enteringObject );
            object lastTraversedEntranceBody = GetObjectByTag(lastTraversedEntranceTag);
            AssignCommand( enteringObject, JumpToObject(
                GetIsObjectValid( lastTraversedEntranceBody ) ?
                lastTraversedEntranceBody :
                GetWaypointByTag( Mod_GATE_WAYPOINT_TAG )
            ) );
            SetLocalInt( enteringObject, RW_PC_hasToIgnoreAreaOnExitEvent_VN, TRUE );
            return;
        }
    }
    ExecuteScript( RW_COMMON_AREA_ON_ENTER_SCRIPT, thisAreaBody );

//    SendMessageToPC( GetFirstPC(), "RW_Area_onEnter: end" );
}
