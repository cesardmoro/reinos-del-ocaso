//::///////////////////////////////////////////////
//:: OnUsed placeable eventscript
//:: prc_plc_used
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONUSED);
}