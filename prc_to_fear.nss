//::///////////////////////////////////////////////
//:: Thrall of Orcus Touch of Fear
//:: prc_to_fear
//:://////////////////////////////////////////////
//:: Causes an area of fear that reduces Will Saves
//:: and applies the frightened effect.
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    float fDuration = RoundsToSeconds(10);
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eFear = EffectFrightened();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    float fDelay;
    //Link the fear and mind effects
    effect eLink = EffectLinkEffects(eFear, eMind);
    eLink = EffectLinkEffects(eLink, eDur);
    object oTarget;
    
    int CasterLvl = 10+ SPGetPenetr();

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            fDelay = GetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
            //Make SR Check
            if(!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
            {
                int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
                //Make a will save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ nDC), SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
                }
            }
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    }
}

