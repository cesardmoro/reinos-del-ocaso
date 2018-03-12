//::///////////////////////////////////////////////
//:: OnLocked placeable eventscript
//:: prc_plc_lock
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONLOCK);
}