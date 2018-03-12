/******** RandomWay PoolsManager default pools descriptors script **************
Author: Inquisidor
*******************************************************************************/
#include "RW_facade_inc"

void main() {
    object initiator = OBJECT_SELF;
//    SendMessageToPC( GetFirstPC(), "RW_PM_defPDS: begin - area="+GetName(GetArea(initiator)) );

    int defaultPermitedPoolsForDoorsDestination = 0;
    int defaultPermitedPoolsForOrientedTriggersDestination = 0;
    string eligibleAreasWSDescriptor = "";

    int poolIndex = GetLocalInt( initiator, RW_Initiator_poolIndex_AN );
    switch( poolIndex ) {

        case RW_Pool_Index_CRYPT:
            defaultPermitedPoolsForDoorsDestination = ~(1<<(RW_Pool_Index_BEHOLDER_CAVES-1)); // all except beholder caves
            defaultPermitedPoolsForOrientedTriggersDestination = 1<<(RW_Pool_Index_CRYPT-1); // only same pool
            eligibleAreasWSDescriptor =
            //  "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####,###"     EPFMR
                "rwa_crypt_01                    0023,020"+ // 10111 bidirectional route, dungeon end
                "rwa_crypt_02                    0007,015"+ // 00111 bidirectional route
                "rwa_crypt_03                    0007,015"+ // 00111 bidirectional route
                "rwa_crypt_04                    0023,040"+ // 10111 bidirectional route, dungeon end
                "rwa_crypt_05                    0007,060"+ // 00111 bidirectional route
                "rwa_crypt_06                    0031,040"+ // 11111 bidirectional route, has a portal, dungeon end
                "rwa_crypt_07                    0031,015"+ // 11111 bidirectional route, has a portal, dungeon end
                "rwa_crypt_08                    0027,030"  // 11011 male way route, has a portal, dungeon end
            ;
            break;

        case RW_Pool_Index_DROW_INTERIOR:
            defaultPermitedPoolsForDoorsDestination = ~(1<<(RW_Pool_Index_BEHOLDER_CAVES-1)); // all except beholder caves
            defaultPermitedPoolsForOrientedTriggersDestination = 1<<(RW_Pool_Index_DROW_INTERIOR-1); // only same pool
            eligibleAreasWSDescriptor =
            //  "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####,###"     EPFMR
                "Area_rw7_1                      0015,010"+ // 01111
                "Area_rw7_2                      0023,030"+ // 10111
                "Area_rw7_3                      0007,010"  // 00111
            ;
            break;

        case RW_Pool_Index_DUNGEON:
            defaultPermitedPoolsForDoorsDestination = ~(1<<(RW_Pool_Index_BEHOLDER_CAVES-1)); // all except beholder caves
            defaultPermitedPoolsForOrientedTriggersDestination = 1<<(RW_Pool_Index_DUNGEON-1); // only same pool
            eligibleAreasWSDescriptor =
            //  "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####,###"     EPFMR
                "Area_rw8_1                      0007,040"+ // 00111
                "Area_rw8_2                      0015,030"+ // 01111
                "Area_rw8_3                      0023,010"+ // 10111
                "Area_rw8_4                      0015,020"  // 01111
            ;
            break;
    }

    SetLocalInt( initiator, RW_Initiator_defaultPermitedPoolsForDoorsDestination_AN, defaultPermitedPoolsForDoorsDestination );
    SetLocalInt( initiator, RW_Initiator_defaultPermitedPoolsForOrientedTriggersDestination_AN, defaultPermitedPoolsForOrientedTriggersDestination );
    SetLocalString( initiator, RW_Initiator_eligibleAreasList_AN, eligibleAreasWSDescriptor );

//    SendMessageToPC( GetFirstPC(), "RW_PM_defPDS: end - area="+GetName(GetArea(initiator)) );
}


