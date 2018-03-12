//::///////////////////////////////////////////////
//:: OnUserDefined door eventscript
//:: prc_door_ud
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONUSERDEFINED);
}