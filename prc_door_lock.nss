//::///////////////////////////////////////////////
//:: OnLocked door eventscript
//:: prc_door_lock
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONLOCK);
}