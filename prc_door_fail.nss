//::///////////////////////////////////////////////
//:: OnFailToOpen door eventscript
//:: prc_door_fail
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONFAILTOOPEN);
}