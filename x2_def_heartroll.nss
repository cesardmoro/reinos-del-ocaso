//::///////////////////////////////////////////////
//:: Name x2_def_heartbeat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default Heartbeat script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////

void main() {
//  Borrado porque es inutil
//  if(GetLocalInt(GetArea(OBJECT_SELF), "numero") == 0)
//        return;

     int iDamageRecieved = GetLocalInt(OBJECT_SELF, "TROLL_DAMAGE_RECIEVED");
    int iMax = GetMaxHitPoints();
    int iCurrent = GetCurrentHitPoints();
    // This fires before the rest of the On Heartbeat file does
    if(iDamageRecieved < iMax)
    {
        // Heal self as long as we have less current hit points then
        // max damage - recieved.
        if(iCurrent < (iMax - iDamageRecieved))
        {
            // Regenerate
            int iRegenamount = iMax - iDamageRecieved;
            if(iRegenamount > 5) iRegenamount = 5;
            // Heal
            effect eRegerate = EffectHeal(iRegenamount);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eRegerate, OBJECT_SELF);
        }
    }

    ExecuteScript("nw_c2_default1", OBJECT_SELF);
}
