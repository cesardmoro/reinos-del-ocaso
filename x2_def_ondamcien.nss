//::///////////////////////////////////////////////
//:: Name x2_def_ondamage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default OnDamaged script
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: June 11/03
//:://////////////////////////////////////////////
#include "SPC_inc"

void main()
{
    //--------------------------------------------------------------------------
    // GZ: 2003-10-16
    // Make Plot Creatures Ignore Attacks
    //--------------------------------------------------------------------------
    if (GetPlotFlag(OBJECT_SELF))
    {
        return;
    }
    if(GetDamageDealtByType(DAMAGE_TYPE_SLASHING) == 1)
    {
    object oCopia = CopyObject(OBJECT_SELF, GetLocation(OBJECT_SELF), OBJECT_INVALID, "copia");
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(OBJECT_SELF)/2), OBJECT_SELF));
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(OBJECT_SELF)/2), oCopia));
    return;
    }

    //--------------------------------------------------------------------------
    // Execute old NWN default AI code
    //--------------------------------------------------------------------------
    ExecuteScript("nw_c2_default6", OBJECT_SELF);

    // Linea movida a "nw_c2_default6"
    // SisPremioCombate_onDamage( GetLastDamager(), GetTotalDamageDealt() );
}
