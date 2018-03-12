//::///////////////////////////////////////////////
//:: OnPerception NPC eventscript
//:: prc_npc_percep
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"

void main()
{
    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONPERCEPTION);
}