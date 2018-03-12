//::///////////////////////////////////////////////
//:: OnDamaged door eventscript
//:: prc_door_damaged
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONDAMAGED);
}