//::///////////////////////////////////////////////
//:: Onheartbeat door eventscript
//:: prc_door_hb
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONHEARTBEAT);
}