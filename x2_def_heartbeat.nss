//::///////////////////////////////////////////////
//:: Name x2_def_heartbeat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Default Heartbeat script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////
//
#include "RS_inc"

void main() {

    if( GetLocalInt( OBJECT_SELF, "merc" ) )
        ExecuteScript("NW_CH_AC1", OBJECT_SELF);
    else {
        ExecuteScript("nw_c2_default1", OBJECT_SELF);

        // Linea movida a "nw_c2_default1"
        //RS_onHeartbeat();
    }
}
