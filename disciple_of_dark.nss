//::///////////////////////////////////////////////
//:: Disciple of darkness feat
//:: disciple_of_dark.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
+20 attack bonus for 9 seconds.
CHANGE: Miss chance still applies, unlike rules.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

#include "prc_alterations"

void main()
{
    if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
    {
        //Declare major variables
        object oTarget;
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);


        // * determine the damage bonus to apply
        effect eAttack = EffectAttackIncrease(20);


        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = eAttack;
        eLink = EffectLinkEffects(eLink, eDur);


        oTarget = OBJECT_SELF;

        //Fire spell cast at event for target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 415, FALSE));
        //Apply VFX impact and bonus effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 9.0);
    }
    else
    {
        SendMessageToPC( OBJECT_SELF, "Para usar esta dote debes ser de alineamiento maligno." );
    }
}

