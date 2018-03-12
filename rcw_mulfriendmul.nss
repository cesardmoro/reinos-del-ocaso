/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "RCW_inc"

void main() {
    object user = GetPCSpeaker();
    SetLocalInt( user, RCW_wandState_VN, RCW_WandState_setFirstTargetFactionBeMutualFriendWithSecondTargetFaction_CN );
    SendMessageToPC( user, "Use the wand again and select the second target." );
}
