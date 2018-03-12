//::///////////////////////////////////////////////
//:: OnClose placeable eventscript
//:: prc_plc_close
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONCLOSE);
}