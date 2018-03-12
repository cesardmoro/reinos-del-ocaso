//::///////////////////////////////////////////////
//:: OnDeath door eventscript
//:: prc_door_death
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONDEATH);
}