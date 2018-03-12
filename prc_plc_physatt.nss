//::///////////////////////////////////////////////
//:: OnPhysicalAttacked door eventscript
//:: prc_plc_physatt
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONATTACKED);
}