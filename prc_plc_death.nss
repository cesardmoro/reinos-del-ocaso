//::///////////////////////////////////////////////
//:: OnDeath placeable eventscript
//:: prc_plc_death
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONDEATH);
}