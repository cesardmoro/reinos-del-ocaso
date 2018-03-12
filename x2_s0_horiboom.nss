//::///////////////////////////////////////////////
//:: Horizikaul's Boom
//:: X2_S0_HoriBoom
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You blast the target with loud and high-pitched
// sounds. The target takes 1d4 points of sonic
// damage per two caster levels (maximum 5d4) and
// must make a Will save or be deafened for 1d4
// rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 22, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003


//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
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


    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oTarget = GetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nCasterLvl = CasterLvl/2;
    int nRounds = d4(1);
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eDeaf = EffectDeaf();
    //Minimum caster level of 1, maximum of 15.
    if(nCasterLvl == 0)
    {
        nCasterLvl = 1;
    }
    else if (nCasterLvl > 5)
    {
        nCasterLvl = 5;
    }

    CasterLvl +=SPGetPenetr();

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Roll damage
            int nDam = d4(nCasterLvl);
            //Enter Metamagic conditions
            if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
            {
                nDam = 4 * nCasterLvl; //Damage is at max
            }
            if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
            {
                nDam = nDam + nDam/2; //Damage/Healing is +50%
            }
            //Set damage effect
            effect eDam = EffectDamage(nDam, SPGetElementalDamageType(DAMAGE_TYPE_SONIC));
            //Apply the MIRV and damage effect
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(nRounds));
            }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
