/************* RandomWay - treasure chest - onOpen event handler ***************
Author: Inquisidor
Description: must be tied to the onOpen event of any container that lays in the
final area of a dungeon, and which is designated to generate a reward the first
time it is opened since the random way instance where it lays was generated.
*******************************************************************************/
#include  "RW_implement_inc"


void main() {
    object container = OBJECT_SELF;
    object initiator = GetLocalObject( GetArea(container), RW_Area_initiatorTransition_VN );
    if( GetIsObjectValid( initiator ) ) {
        // The expiration date is used to identify random way instances. Treasure is generated only if the current random instance is different than the instance where this container lays the last time it was opened.
        int currentRandomWayInstanceId = RW_Initiator_getRandomWayInstanceId( initiator );
        if( GetLocalInt( container, RW_Chest_rwInstanceIdWhenLastOpened_VN ) != currentRandomWayInstanceId ) {
            SetLocalInt( container, RW_Chest_rwInstanceIdWhenLastOpened_VN, currentRandomWayInstanceId );
            float rewardFraction = GetLocalFloat( container, RW_Chest_rewardFraction_VN );
            RW_Dungeon_createFinalReward( initiator, container, rewardFraction );
        }
    }
}
