//::///////////////////////////////////////////////
//:: OnUnocked placeable eventscript
//:: prc_plc_unlock
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONUNLOCK);
}