//::///////////////////////////////////////////////
//:: Name    Door Auto-Close and Lock System
//:: FileName   drcls
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By:  David Poole
//:: Created On:  8-3-04
//:://////////////////////////////////////////////

void main()
{
//sets the target to me
object oDoor=OBJECT_SELF;
//closes me after 10 seconds
DelayCommand(15.0, ActionCloseDoor(oDoor));
//locks me after 10.1 seconds
DelayCommand(15.1, SetLocked(oDoor, TRUE));
}

