//:://////////////////////////////////////////////
//:: Listener script used in marking teleport locations
//:: prc_telep_lname
//:://////////////////////////////////////////////
/** @file
    This script stores the string spoken by the player
    into a local variable on them and then destroys
    the listener to prevent it from overwriting
    the value with something else.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 20.06.2005
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_listener"

void main()
{
    // Store the spoken value
    string sName = GetMatchedSubstring(0);
    SetLocalString(GetLastSpeaker(), "PRC_Teleport_LocationBeingStored_Name", sName);
    //                               "Name gotten:"
    SendMessageToPC(GetLastSpeaker(), GetStringByStrRef(16825307) + " " + sName);

    // Destroy the listener
    DestroyListener(OBJECT_SELF);
}