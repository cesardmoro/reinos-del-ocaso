/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "RCW_inc"

void main() { // substract 50 to the reputation of the first target's faction toward the second target creature
    object user = GetPCSpeaker();
    SetLocalInt( user, RCW_wandState_VN, RCW_WandState_substract50ToFirstTargetFactionReputationTowardSecondTargetCreature_CN );
    SendMessageToPC( user, "Use the wand again and select the second target." );
}
