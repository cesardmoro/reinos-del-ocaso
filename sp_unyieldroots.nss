#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x0_i0_spells"

int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    effect eHold = EffectCutsceneImmobilize();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDuration = CasterLvl;
    
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    
    int nMetaMagic = GetMetaMagicFeat();

    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
       nDuration = nDuration *2;    //Duration is +100%


    effect eBad = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eBad))
    {
        if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
            GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
            GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
            GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
            GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
            {
                //Remove effect if it is negative.
                if(!GetIsSupernaturalCurse(eBad))
                    RemoveEffect(oTarget, eBad);
            }
        eBad = GetNextEffect(oTarget);
    }


    //Link Entangle and Hold effects
    effect eLink = EffectLinkEffects(eHold, eEntangle);


 
 
    eLink = EffectLinkEffects(eLink,EffectSpellImmunity(SPELL_BIGBYS_FORCEFUL_HAND));
    eLink = EffectLinkEffects(eLink,EffectSpellImmunity(SPELL_EARTHQUAKE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_AC_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_ATTACK_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_DAMAGE_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_DAMAGE_IMMUNITY_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_SAVING_THROW_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_SKILL_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_SPELL_RESISTANCE_DECREASE));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
    eLink = EffectLinkEffects(eLink,EffectImmunity(IMMUNITY_TYPE_POISON));

    eLink = EffectLinkEffects(eLink,EffectRegenerate(30,6.0));
    
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT,4);
    eSave = EffectLinkEffects(eSave,EffectSavingThrowIncrease(SAVING_THROW_WILL,4));
    eSave = EffectLinkEffects(eSave,EffectSavingThrowDecrease(SAVING_THROW_REFLEX,4));


    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSave, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
