//::///////////////////////////////////////////////
//:: OnSpellCastAt door eventscript
//:: prc_plc_spell
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_PLACEABLE_ONSPELL);
}