//::///////////////////////////////////////////////
//:: OnOpen door eventscript
//:: prc_door_open
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONOPEN);
}