//::///////////////////////////////////////////////
//:: OnUnlock door eventscript
//:: prc_door_unlock
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONUNLOCK);
}