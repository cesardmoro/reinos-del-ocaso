//::///////////////////////////////////////////////
//:: OnDamaged placeable eventscript
//:: prc_plc_damaged
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONDAMAGED);
}