//::///////////////////////////////////////////////
//:: Frightful Prescence
//:: prc_hext_fright.nss
//:://////////////////////////////////////////////
//:: Causes an area of fear that applies either the
//:: Fear effect or the Doom effect.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 10, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    //Declare major variables
    int nDur = d6(5);
    float fDuration = RoundsToSeconds(nDur);
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eFear = EffectFrightened();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    float fDelay;
    //Link the fear and mind effects
    effect eLink = EffectLinkEffects(eFear, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVisD = EffectVisualEffect(VFX_IMP_DOOM);
    effect eLinkD = CreateDoomEffectsLink();


    int nDC = (10 + GetLevelByClass(CLASS_TYPE_HEXTOR, OBJECT_SELF) + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF));

    object oTarget;

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Get first target in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if (!GetLevelByClass(CLASS_TYPE_HEXTOR, oTarget))
        {
            fDelay = GetRandomDelay();
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
                //Make a will save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
                {
                    //Apply the linked effects and the VFX impact
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
		}
            	else
		{
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkD, oTarget, fDuration);
	            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisD, oTarget);
		}
        }
        //Get next target in the spell cone
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation(), TRUE);
    }
}
