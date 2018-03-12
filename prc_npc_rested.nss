//::///////////////////////////////////////////////
//:: OnRested NPC eventscript
//:: prc_npc_rested
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"

void main()
{
    // Execute the stuff in prc_rest for REST_EVENTTYPE_REST_STARTED and REST_EVENTTYPE_REST_FINISHED
    SetLocalInt(OBJECT_SELF, "prc_rest_eventtype", REST_EVENTTYPE_REST_STARTED);
    ExecuteScript("prc_rest", OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "prc_rest_eventtype", REST_EVENTTYPE_REST_FINISHED);
    ExecuteScript("prc_rest", OBJECT_SELF);
    DeleteLocalInt(OBJECT_SELF, "prc_rest_eventtype");
    
    
    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONRESTED);
}