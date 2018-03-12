//::///////////////////////////////////////////////
//:: OnClose door eventscript
//:: prc_door_close
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONCLOSE);
}