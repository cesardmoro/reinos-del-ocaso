//::///////////////////////////////////////////////
//:: Name x2_def_endcombat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default Combat Round End script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main()
{
   int EsMerc = GetLocalInt( OBJECT_SELF, "merc" );
    if( EsMerc == 1 )
    ExecuteScript("NW_CH_AC3", OBJECT_SELF);

   if( EsMerc == 0 ) {
    ExecuteScript("nw_c2_default3", OBJECT_SELF);
    }
}
