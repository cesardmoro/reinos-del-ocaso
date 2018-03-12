//::///////////////////////////////////////////////
//:: Name x2_def_ondisturb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default OnDisturbed script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main() {
//    Borrado porque es inutil.
//    if(GetLocalInt(GetArea(OBJECT_SELF), "numero") == 0)
//        return;

    if( GetLocalInt( OBJECT_SELF, "merc" ) )
        ExecuteScript("NW_CH_AC3", OBJECT_SELF);
    else
        ExecuteScript( "nw_c2_default8", OBJECT_SELF);

}
