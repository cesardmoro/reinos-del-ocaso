//::///////////////////////////////////////////////
//:: Healing Sting
//:: X2_S0_HealStng
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You inflict 1d6 +1 point per level damage to
    the living creature touched and gain an equal
    amount of hit points. You may not gain more
    hit points then your maximum with the Healing
    Sting.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 19, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller, 19/10/2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"


#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
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
    object oTarget = GetSpellTargetObject();
    //object oCaster = GetCurrentHitPoints(OBJECT_SELF);
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage = d6(1) + nCasterLvl;

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nDamage = 6 + nCasterLvl;//Damage is at max
    }
    else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
         nDamage += nDamage / 2;
    }

    nCasterLvl +=SPGetPenetr();


    //Declare effects
    effect eHeal = EffectHeal(nDamage);
    effect eVs = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eLink = EffectLinkEffects(eVs,eHeal);

    effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eLink2 = EffectLinkEffects(eVis,eDamage);

    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        if(!GetIsReactionTypeFriendly(oTarget) &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD &&
            MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT &&
            !GetHasSpellEffect(SPELL_NEGATIVE_ENERGY_PROTECTION, oTarget))
        {
           //Signal spell cast at event

            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Spell resistance
            if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nCasterLvl))
            {
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
                {
                    //Apply effects to target and caster
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, OBJECT_SELF);
                    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
                }
            }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
