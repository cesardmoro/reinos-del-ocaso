//::///////////////////////////////////////////////
//:: OnAreaTransitionClick door eventscript
//:: prc_door_transit
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONTRANSITION);
}