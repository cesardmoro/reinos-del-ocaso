//::///////////////////////////////////////////////
//:: OnSpellCastAt door eventscript
//:: prc_door_spell
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_DOOR_ONSPELL);
}