//::///////////////////////////////////////////////
//:: Hammer of the Gods
//:: [NW_S0_HammGods.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Does 1d8 damage to all enemies within the
//:: spells 20m radius and dazes them if a
//:: Will save is failed.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 21, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
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
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);




    int nCasterLvl = CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    effect eDam;
    effect eDaze = EffectBlindness();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eStrike = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
    float fDelay;
    int nDamageDice = nCasterLvl/2;
    if(nDamageDice == 0)
    {
        nDamageDice = 1;
    }
    //Limit caster level
    if (nDamageDice > 5)
    {
        nDamageDice = 5;
    }
    int nDamage;
    int nPenetr = CasterLvl +SPGetPenetr();

    //Apply the holy strike VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, GetSpellTargetLocation());
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
       //Make faction checks
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HAMMER_OF_THE_GODS));
            //Make SR Check
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
            {
                fDelay = GetRandomDelay(0.6, 1.3);
                //Roll damage
                nDamage = d8(nDamageDice);
                //Make metamagic checks
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                    nDamage = 8 * nDamageDice;
                }
                else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                    nDamage = FloatToInt( IntToFloat(nDamage) * 1.5 );
                }
                int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);

                int mustDaze = FALSE;
                //Make a will save for half damage and negation of daze effect
                if (PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ nDC), SAVING_THROW_TYPE_DIVINE, OBJECT_SELF, 0.5))
                {
                    nDamage = nDamage / 2;
                }
                else
                {
                    mustDaze = TRUE;
                }
                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE );
                //Apply the VFX impact and damage effect only if target's alignment is oppossite to caster's alignment
                int casterAlignment = GetAlignmentGoodEvil(OBJECT_SELF);
                int targetAlignment = GetAlignmentGoodEvil(oTarget);
                if ( (casterAlignment == ALIGNMENT_EVIL && targetAlignment == ALIGNMENT_GOOD) ||
                     (casterAlignment == ALIGNMENT_GOOD && targetAlignment == ALIGNMENT_EVIL) ||
                     (casterAlignment == ALIGNMENT_LAWFUL && targetAlignment == ALIGNMENT_CHAOTIC) ||
                     (casterAlignment == ALIGNMENT_CHAOTIC && targetAlignment == ALIGNMENT_LAWFUL)
                    )
                {
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    if ( mustDaze )
                    {
                        //Apply daze effect
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(d4()),TRUE,-1,CasterLvl));
                    }
                }
             }
        }
        //Get next target in shape
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
    }



DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
