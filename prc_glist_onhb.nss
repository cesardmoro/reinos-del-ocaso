//:://////////////////////////////////////////////
//:: Generic Listener object OnHearbeat script
//:: prc_glist_onhb
//:://////////////////////////////////////////////
/** @file
    The generic listener object's heartbeat script.
    If the listener is listening to a single object,
    makes sure the target is still a valid object.
    If it isn't, the listener deletes itself.
    
    If the listener is listening at a location,
    returns the listener to that location if it had moved.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 19.06.2005
//:://////////////////////////////////////////////

#include "prc_inc_listener"
#include "inc_utility"

void main()
{
    object oListener = OBJECT_SELF;
    // Check if we are listening to a single creature or an area
    if(GetLocalInt(oListener, "PRC_GenericListener_ListenToSingle"))
    {
        object oListeningTo = GetLocalObject(oListener, "PRC_GenericListener_ListeningTo");
        if(!GetIsObjectValid(oListeningTo))
            DestroyListener(oListener);

        DoDebug("Listener distance to listened: " + FloatToString(GetDistanceBetween(oListener, oListeningTo))
                + ". In the same area: " + (GetArea(oListener) == GetArea(oListeningTo) ? "TRUE":"FALSE"));
    }
    // An area. Just make sure the listener stays there
    else
    {
        if(GetLocation(oListener) != GetLocalLocation(oListener, "PRC_GenericListener_ListeningLocation"))
            AssignCommand(oListener, JumpToLocation(GetLocalLocation(oListener, "PRC_GenericListener_ListeningLocation")));
    }

    // Handle timers
    int nVFXTimer = GetLocalInt(oListener, "PRC_GenericListener_VFXRefreshTimer") - 1;
    if(!nVFXTimer)
    {
        // Loop and remove the previous invisibility effect
        effect eTest = GetFirstEffect(oListener);
        while(GetIsEffectValid(eTest))
        {
            if(GetEffectType(eTest) == EFFECT_TYPE_VISUALEFFECT)
                RemoveEffect(oListener, eTest);
            eTest = GetNextEffect(oListener);
        }

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oListener, 9999.0f);
        nVFXTimer = 1500;
    }
    SetLocalInt(oListener, "PRC_GenericListener_VFXRefreshTimer", nVFXTimer);

    if(GetLocalInt(oListener, "PRC_GenericListener_HasLimitedDuration"))
    {
        int nDeathTimer = GetLocalInt(oListener, "PRC_GenericListener_DestroyTimer") - 1;
        if(nDeathTimer <= 0)
        {
            DestroyListener(oListener);
        }

        SetLocalInt(oListener, "PRC_GenericListener_DestroyTimer", nDeathTimer);
        DoDebug("Listener duration left: " + IntToString(nDeathTimer * 6));
    }
}
