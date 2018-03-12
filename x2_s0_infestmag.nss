//::///////////////////////////////////////////////
//:: Infestation of Maggots
//:: X2_S0_InfestMag.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You infest  a target with maggotlike creatures.
    They deal 1d4 points of temporary Constitution
    damage each round. Each round the subject makes
    a new Fortitude save. The spell ends if the
    target succeeds at its saving throw.

    If the targets constitution would drop to 0
    through this spell, and the player is playing
    on hardcore difficulty, the target is
    is killed instantly.

*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 19, 2002
//:://////////////////////////////////////////////
//:: Rewritten By: Georg Zoeller, Oct 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"

void RunInfestImpact(object oTarget, object oCaster, int nSaveDC, int nMetaMagic);

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook


    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(GetSpellId(),oTarget) )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = GetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDuration  = 10 + CasterLvl;

    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration * 2;
    }

    //--------------------------------------------------------------------------
    // Setup DC, effects and projectile timing
    //--------------------------------------------------------------------------
    float  fDist   = GetDistanceToObject(oTarget);
    float  fDelay  = fDist/25.0;
    int    nDC     = GetSpellSaveDC()  + GetChangesToSaveDC(oTarget,OBJECT_SELF);
    effect eDur = EffectVisualEffect   ( VFX_DUR_FLIES );

    CasterLvl +=SPGetPenetr();
    //--------------------------------------------------------------------------
    // Do Safety check, SR and Saves...
    //--------------------------------------------------------------------------
    if(!GetIsReactionTypeFriendly(oTarget))
    {

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

        if(MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay) == 0)
        {
           //---------------------------------------------------------------
           // Apply Effects, Schedule damage ticks
           //---------------------------------------------------------------
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget,RoundsToSeconds(nDuration)));
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS), nDC);
            DelayCommand(fDelay+0.1f, RunInfestImpact(oTarget,oCaster,nDC, nMetaMagic));
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}



void RunInfestImpact(object oTarget, object oCaster, int nSaveDC, int nMetaMagic)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(SPELL_INFESTATION_OF_MAGGOTS,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
         int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));

         if (!PRCMySavingThrow(SAVING_THROW_FORT,oTarget,nSaveDC,SAVING_THROW_TYPE_DISEASE,OBJECT_SELF))
         {
            //------------------------------------------------------------------
            // Setup Ability Score Damage
            //------------------------------------------------------------------
            effect eVis    = EffectVisualEffect   ( VFX_IMP_DISEASE_S );
            int    nDamage = d4(1);

            if ( nMetaMagic == METAMAGIC_MAXIMIZE )
            {
                nDamage = 4;
            }
            else if ( nMetaMagic == METAMAGIC_EMPOWER )
            {
                nDamage = nDamage + (nDamage/2);
            }

            effect eDam = ExtraordinaryEffect  ( EffectAbilityDecrease( ABILITY_CONSTITUTION, nDamage));

            //------------------------------------------------------------------
            // The trick that allows this spellscript to do stacking ability
            // score damage (which is not possible to do from normal scripts)
            // is that the ability score damage is done from a delaycommanded
            // function which will sever the connection between the effect
            // and the SpellId
            //------------------------------------------------------------------

            SPApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);

            //------------------------------------------------------------------
            // If the target already is down to 3 points of constitution,
            // kill him. For immortal creatures, end the spell
            // This only kicks in in Hardcore+ difficulty
            //------------------------------------------------------------------
            if (GetAbilityScore(oTarget,ABILITY_CONSTITUTION)<=3 && GetGameDifficulty() >= GAME_DIFFICULTY_CORE_RULES)
            {
                  if (!GetImmortal(oTarget))
                 {
                     FloatingTextStrRefOnCreature(100932,oTarget);
                     effect eKill = EffectDamage(GetCurrentHitPoints(oTarget)+1);
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT,eKill,oTarget);
                     effect eVfx = EffectVisualEffect(VFX_IMP_DEATH_L);
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT,eVfx,oTarget);
                 }
            }
            else
            {
                 SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget);
                 DelayCommand(6.0, RunInfestImpact(oTarget,oCaster,nSaveDC, nMetaMagic));
            }

         }
         else
         {
            DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_INFESTATION_OF_MAGGOTS));
            GZRemoveSpellEffects(SPELL_INFESTATION_OF_MAGGOTS, oTarget);
         }

    }
}

