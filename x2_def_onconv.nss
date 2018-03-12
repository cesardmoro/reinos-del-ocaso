//::///////////////////////////////////////////////
//:: Name x2_def_onconv
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default On Conversation script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////
#include "VNNPC_inc"

void main() {

    if( VNNPC_onConversation() )
        return;

    if( GetLocalInt( OBJECT_SELF, "merc" ) )
        ExecuteScript("NW_CH_AC4", OBJECT_SELF);
    else
        ExecuteScript("nw_c2_default4", OBJECT_SELF);

}
