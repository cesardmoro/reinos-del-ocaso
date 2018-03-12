//::///////////////////////////////////////////////
//:: OnOpened door eventscript
//:: prc_plc_open
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONOPEN);
}