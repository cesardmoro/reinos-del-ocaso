//:://////////////////////////////////////////////
//:: Teleportation Circle Trigger OnDisarmed
//:: prc_telecirc_dis
//:://////////////////////////////////////////////
/** @file
    OnDisarmed script of the trap trigger created
    by Teleporation Circle spell / power. Destroys
    both itself and the AoE object.

    @author Ornedan
    @data   Created - 2005.10.26
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_utility"

void main()
{
    if(DEBUG) DoDebug("ERROR: prc_telecirc_dis running, shouldn't be run!");
    /* Disabled for time being.
    if(DEBUG) DoDebug("prc_telecirc_dis running, disarmed by '" + GetName(GetLastDisarmed()) + "' - '" + GetTag(GetLastDisarmed()) + "'");

    object oTrigger = OBJECT_SELF;
    object oAoE     = GetLocalObject(oTrigger, "AreaOfEffectObject");
    DestroyObject(oAoE);
    DestroyObject(oTrigger);
    */
}