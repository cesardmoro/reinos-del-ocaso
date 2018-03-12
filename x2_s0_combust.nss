//::///////////////////////////////////////////////
//:: Combust
//:: X2_S0_Combust
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
   The initial eruption of flame causes  2d6 fire damage +1
   point per caster level(maximum +10)
   with no saving throw.

   Further, the creature must make
   a Reflex save or catch fire taking a further 1d6 points
   of damage. This will continue until the Reflex save is
   made.

   There is an undocumented artificial limit of
   10 + casterlevel rounds on this spell to prevent
   it from running indefinitly when used against
   fire resistant creatures with bad saving throws

*/
//:://////////////////////////////////////////////
// Created: 2003/09/05 Georg Zoeller
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "x2_I0_SPELLS"
#include "x2_inc_toollib"
#include "x2_inc_spellhook"

void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic,int EleDmg);

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

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
    // Calculate the save DC
    //--------------------------------------------------------------------------
    int nLevel = PRCGetCasterLevel(OBJECT_SELF);

    int nDC = (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,OBJECT_SELF));
    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_FIRE);


    //--------------------------------------------------------------------------
    // Calculate the damage, 2d6 + casterlevel, capped at +10
    //--------------------------------------------------------------------------
    int nDamage=nLevel;
    if (nDamage > 10)
    {
        nDamage = 10;
    }
    int nMetaMagic = GetMetaMagicFeat();
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nDamage += 12;//Damage is at max
    }
    else
    {
        nDamage  += d6(2);
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
        {
            nDamage = nDamage + (nDamage/2);//Damage/Healing is +50%
        }
    }

    //--------------------------------------------------------------------------
    // Calculate the duration (we need a duration or bad things would happen
    // if someone is immune to fire but fails his safe all the time)
    //--------------------------------------------------------------------------
    int nDuration = 10 + nLevel;
    if (nDuration < 1)
    {
        nDuration = 10;
    }

    //--------------------------------------------------------------------------
    // Setup Effects
    //--------------------------------------------------------------------------
    effect eDam      = EffectDamage(nDamage, EleDmg);
    effect eDur      = EffectVisualEffect(498);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

       //-----------------------------------------------------------------------
       // Check SR
       //-----------------------------------------------------------------------
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nLevel+SPGetPenetr()))
        {

           //-------------------------------------------------------------------
           // Apply VFX
           //-------------------------------------------------------------------
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            TLVFXPillar(VFX_IMP_FLAME_M, GetLocation(oTarget), 5, 0.1f,0.0f, 2.0f);

            //------------------------------------------------------------------
            // This spell no longer stacks. If there is one of that type,
            // that's enough
            //------------------------------------------------------------------
            if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_INFERNO,oTarget)  )
            {
                FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
                return;
            }

            //------------------------------------------------------------------
            // Apply the VFX that is used to track the spells duration
            //------------------------------------------------------------------
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));

            //------------------------------------------------------------------
            // Save the spell save DC as a variable for later retrieval
            //------------------------------------------------------------------
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST), nDC);

            //------------------------------------------------------------------
            // Tick damage after 6 seconds again
            //------------------------------------------------------------------
            DelayCommand(6.0, RunCombustImpact(oTarget,oCaster,nLevel, nMetaMagic,EleDmg));
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}

void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic,int EleDmg)
{
     //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(SPELL_COMBUST,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {

        int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));

        if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
        {
            //------------------------------------------------------------------
            // Calculate the damage, 1d6 + casterlevel, capped at +10
            //------------------------------------------------------------------
            int nDamage = nLevel;
            if (nDamage > 10)
            {
                nDamage = 10;
            }
            if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
            {
                nDamage += 6;
            }
            else
            {
                nDamage  += d6();
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                    nDamage = nDamage + (nDamage/2);
                }
            }

            effect eDmg = EffectDamage(nDamage,EleDmg);
            effect eVFX = EffectVisualEffect(VFX_IMP_FLAME_S);

            SPApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);

            //------------------------------------------------------------------
            // After six seconds (1 round), check damage again
            //------------------------------------------------------------------
            DelayCommand(6.0f,RunCombustImpact(oTarget,oCaster, nLevel,nMetaMagic,EleDmg));
        }
        else
        {
            DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));
            GZRemoveSpellEffects(SPELL_COMBUST, oTarget);
        }

   }

}





