/************************ Reputation Control Wand ******************************
Package: reputation control wand - a conversation node script
Author: Inquisidor
*******************************************************************************/
#include "RCW_inc"

int StartingConditional() {
    RCW_refreshTokens( GetPCSpeaker() );
    return TRUE;
}
