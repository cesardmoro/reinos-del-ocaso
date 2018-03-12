//::///////////////////////////////////////////////
//:: OnUserDefined placeable eventscript
//:: prc_plc_ud
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONUSERDEFINED);
}