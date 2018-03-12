//:://////////////////////////////////////////////
//:: Teleportation Circle Auxiliary
//:: prc_telecirc_aux
//:://////////////////////////////////////////////
/** @file
    Teleportation Circle auxiliary script, run on
    the area of effect object created by the
    spell / power or on the PC when they make
    their selection about the target of the circle.

    Creates the trapped trigger and, if this
    is supposed to be a visible circle, starts
    VFX heartbeat.
    Also, starts monitor heartbeats on itself
    and the trigger.

    @author Ornedan
    @date   Created - 2005.10.25
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_telecircle"

void MonitorHB(object oAnother)
{
    if(DEBUG) DoDebug("prc_telecirc_aux: Running MonitorHB on " + GetTag(OBJECT_SELF));
    if(!GetIsObjectValid(oAnother))
    {
        if(DEBUG) DoDebug("prc_telecirc_aux: Another no longer exists");
        DestroyObject(OBJECT_SELF);
    }
    else
        DelayCommand(6.0f, MonitorHB(oAnother));
}

void VFXHB(location lCenter)
{
    // Do a smoke puff pentagram. Cliche - but meh :P
    DrawPentacle(DURATION_TYPE_INSTANT, VFX_FNF_SMOKE_PUFF, lCenter,
                 FeetToMeters(5.0f), // Radius
                 0.0f, // VFX Duration
                 50,   // # of nodes
                 2.0f, // Number of revolutions
                 6.0f, // Time for drawing
                 0.0f, "z" // Angle offset and axis
                 );
    DrawCircle(DURATION_TYPE_INSTANT, VFX_FNF_SMOKE_PUFF, lCenter, FeetToMeters(5.0f),
               0.0f, 36, 1.0f, 6.0f, 0.0f, "z"
               );

    DelayCommand(6.0f, VFXHB(lCenter));
}

void main()
{
    // Check whether we are running for the PC who selected the location the circle points at
    if(GetIsPC(OBJECT_SELF))
    {
        object oPC = OBJECT_SELF;
        // Finish the casting
        TeleportationCircleAux(oPC);
    }
    // Or for the circle AoE to initialise it
    else
    {
        object oAoE      = OBJECT_SELF;
        int bVisible     = GetLocalInt(oAoE, "IsVisible");
        location lTarget = GetLocalLocation(oAoE, "TargetLocation");
/* Disabled for time being.
        // Get a reference to an original placeable
        object oOrig = GetObjectByTag(bVisible ?
                                       "PRC_TELECIRCLE_TRIG_VISIBLE_ORIG" :
                                       "PRC_TELECIRCLE_TRIG_HIDDEN_ORIG"
                                      );
        if(!GetIsObjectValid(oOrig))
        {
            if(DEBUG) DoDebug("prc_telecirc_aux: ERROR: Cannot find original trigger!");
            else WriteTimestampedLogEntry("prc_telecirc_aux: ERROR: Cannot find original trigger!");
        }
        // Copy it
        object oTrigger = CopyObject(oOrig, GetLocation(oOrig), OBJECT_INVALID,
                                     bVisible ?
                                      "PRC_TELECIRCLE_TRIG_VISIBLE" :
                                      "PRC_TELECIRCLE_TRIG_HIDDEN"
                                     );
        if(!GetIsObjectValid(oTrigger))
        {
            if(DEBUG) DoDebug("prc_telecirc_aux: ERROR: Cannot create trigger copy!");
            else WriteTimestampedLogEntry("prc_telecirc_aux: ERROR: Cannot create trigger copy!");
            return;
        }

        // Store references to each other
        SetLocalObject(oAoE, "Trigger", oTrigger);
        SetLocalObject(oTrigger, "AreaOfEffectObject", oAoE);

        // Start monitor HB
        AssignCommand(oAoE, MonitorHB(oTrigger));
        AssignCommand(oTrigger, MonitorHB(oAoE));
*/
        // Do VFX
        if(bVisible)
            AssignCommand(oAoE, VFXHB(GetLocation(oAoE)));

        // Mark the initalisation being done
        SetLocalInt(oAoE, "PRC_TeleCircle_AoE_Inited", TRUE);
    }
}