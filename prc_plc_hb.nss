//::///////////////////////////////////////////////
//:: OnHeartbeat placeable eventscript
//:: prc_plc_hb
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONHEARTBEAT);
}