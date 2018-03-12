//::///////////////////////////////////////////////
//:: Name x2_def_rested
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default On Rested script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

#include "Speed_inc"

void main()
{

    Speed_applyModifiedSpeed();

    if ( GetLocalInt( OBJECT_SELF, "merc" ) == 1 ) {

        ExecuteScript("NW_CH_AC3", OBJECT_SELF);

    } else {

        ExecuteScript("nw_c2_defaulta", OBJECT_SELF);

    }
}
