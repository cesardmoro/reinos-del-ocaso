//::///////////////////////////////////////////////
//:: Healing Circle
//:: NW_S0_HealCirc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Positive energy spreads out in all directions
// from the point of origin, curing 1d8 points of
// damage plus 1 point per caster level (maximum +20)
// to nearby living allies.
//
// Like cure spells, healing circle damages undead in
// its area rather than curing them.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18,2000
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2004

#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
  object oTarget;
  
  int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);


  

  int nCasterLvl = CasterLvl;
  int nDamagen, nModify, nHurt, nHP;
  int nMetaMagic = GetMetaMagicFeat();
  effect eKill;
  effect eHeal;
  effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_M);
  effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_20);
  float fDelay;
  //Limit caster level
  if (nCasterLvl > 20)
  {
    nCasterLvl = 20;
  }
  
  CasterLvl +=SPGetPenetr();
  
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    //Get first target in shape
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        //Check if racial type is undead
        if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEALING_CIRCLE));
                //Make SR check
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
                {
                    int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
                    nModify = d8() + nCasterLvl;
                    //Make metamagic check
                    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_POSITIVE, FALSE);
                    if (nMetaMagic == METAMAGIC_MAXIMIZE || iBlastFaith)
                    {
                        nModify = 8 + nCasterLvl;
                    }
                    //Make Fort save
                    if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ nDC), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                        nModify /= 2;
                    }
                    //Calculate damage
                    nHurt =  nModify;
                    //Set damage effect
                    eKill = EffectDamage(nHurt, DAMAGE_TYPE_POSITIVE);
                    //Apply damage effect and VFX impact
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        else
        {
            // * May 2003: Heal Neutrals as well
            if(!GetIsReactionTypeHostile(oTarget) || GetFactionEqual(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEALING_CIRCLE, FALSE));
                nHP = d8();
                //Enter Metamagic conditions
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                    nHP =8;//Damage is at max
                }
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                    nHP = nHP + (nHP/2); //Damage/Healing is +50%
                }
                //Set healing effect
                nHP = nHP + nCasterLvl;
                eHeal = EffectHeal(nHP);
                //Apply heal effect and VFX impact
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
        }
        //Get next target in the shape
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }
    


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
