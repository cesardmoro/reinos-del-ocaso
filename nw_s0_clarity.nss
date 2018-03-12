//::///////////////////////////////////////////////
//:: Clarity
//:: NW_S0_Clarity.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell removes Charm, Daze, Confusion, Stunned
    and Sleep.  It also protects the user from these
    effects for 1 turn / level.  Does 1 point of
    damage for each effect removed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    effect eImm1 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eDam = EffectDamage(1, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eImm1, eVis);
    eLink = EffectLinkEffects(eLink, eDur);

    object oTarget = GetSpellTargetObject();
    effect eSearch = GetFirstEffect(oTarget);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    int bValid;
    int bVisual;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLARITY, FALSE));
    //Search through effects
    if( !GetIsPC(OBJECT_SELF) || GetIsDMPossessed(OBJECT_SELF) || GetGold(OBJECT_SELF) > 9)
    {
        TakeGoldFromCreature(10, OBJECT_SELF, TRUE);
        while(GetIsEffectValid(eSearch))
        {
            bValid = FALSE;
            //Check to see if the effect matches a particular type defined below
            if (GetEffectType(eSearch) == EFFECT_TYPE_DAZED)
            {
                bValid = TRUE;
            }
            else if(GetEffectType(eSearch) == EFFECT_TYPE_CHARMED)
            {
                bValid = TRUE;
            }
            else if(GetEffectType(eSearch) == EFFECT_TYPE_SLEEP)
            {
                bValid = TRUE;
            }
            else if(GetEffectType(eSearch) == EFFECT_TYPE_CONFUSED)
            {
                bValid = TRUE;
            }
            else if(GetEffectType(eSearch) == EFFECT_TYPE_STUNNED)
            {
                bValid = TRUE;
            }
            //Apply damage and remove effect if the effect is a match
            if (bValid == TRUE)
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                RemoveEffect(oTarget, eSearch);
                bVisual = TRUE;
            }
            eSearch = GetNextEffect(oTarget);
        }
        float fTime = 30.0  + RoundsToSeconds(nDuration);
        //After effects are removed we apply the immunity to mind spells to the target
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fTime,TRUE,-1,CasterLvl);
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name
}

