//::///////////////////////////////////////////////
//:: Name x2_def_percept
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default On Perception script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////
//#include "SPC_inc"

void main() {

    if( GetLocalInt( OBJECT_SELF, "merc" ) )
        ExecuteScript("NW_CH_AC2", OBJECT_SELF);
    else {
        ExecuteScript("nw_c2_default2", OBJECT_SELF);

        // Linea movia a "nw_c2_default2"
        //SisPremioCombate_onPerception();
    }
}
