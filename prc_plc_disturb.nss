//::///////////////////////////////////////////////
//:: OnDisturbed placeable eventscript
//:: prc_plc_disturb
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONDISTURBED);
}