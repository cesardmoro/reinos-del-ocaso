//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a globe of darkness around those in the area
    of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "x0_i0_spells"
#include "prc_class_const"
#include "x2_inc_spellhook"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    ActionDoCommand(SetAllAoEInts(SPELL_DARKNESS ,OBJECT_SELF, GetSpellSaveDC()));

    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    effect eDark = EffectDarkness();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eDark, eDur);
    effect eLink2 =  EffectLinkEffects(eInvis, eDur);

    object oTarget = GetEnteringObject();
    object oCreator = GetAreaOfEffectCreator();

    int iShadow = GetLevelByClass(CLASS_TYPE_SHADOWLORD, oTarget);
    if (iShadow > 0)
        eLink2 = EffectLinkEffects(eLink2, EffectUltravision());
    if (iShadow > 1)
        eLink2 = EffectLinkEffects(eLink2, EffectConcealment(20));


    // * July 2003: If has darkness then do not put it on it again
    if (GetHasEffect(EFFECT_TYPE_DARKNESS, oTarget) == TRUE)
    {
        return;
    }

    if(GetIsObjectValid(oTarget) && oTarget != oCreator)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCreator))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        }
        else
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        }

        if (iShadow > 0)
          SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget,0.0f,FALSE);
        else
          //Fire cast spell at event for the specified target
          SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE);
    }
    else if (oTarget == oCreator)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
        //Fire cast spell at event for the specified target
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget,0.0f,FALSE);
    }
    //SendMessageToPC(GetFirstPC(), "DarknessOnEnter: DarknessSpellId= "+IntToString(GetSpellId()));



DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}



