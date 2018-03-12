//::///////////////////////////////////////////////
//:: Name x2_def_onblocked
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default OnBlocked script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main()
{

    int EsMerc = GetLocalInt( OBJECT_SELF, "merc" );
    if( EsMerc == 1 )
    ExecuteScript("NW_CH_ACE", OBJECT_SELF);

    if(EsMerc == 0)
    {
     ExecuteScript("nw_c2_defaulte", OBJECT_SELF);
    }
}
