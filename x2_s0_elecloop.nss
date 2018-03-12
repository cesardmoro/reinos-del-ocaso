//::///////////////////////////////////////////////
//:: Gedlee's Electric Loop
//:: X2_S0_ElecLoop
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You create a small stroke of lightning that
    cycles through all creatures in the area of effect.
    The spell deals 1d6 points of damage per 2 caster
    levels (maximum 5d6). Those who fail their Reflex
    saves must succeed at a Will save or be stunned
    for 1 round.

    Spell is standard hostile, so if you use it
    in hardcore mode, it will zap yourself!

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 19 2003
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"


#include "x2_I0_SPELLS"
#include "x2_inc_spellhook"


void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

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


    location lTarget    = GetSpellTargetLocation();
    effect   eStrike    = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    int      nMetaMagic = GetMetaMagicFeat();
    float    fDelay;
    effect   eBeam;
    int      nDamage;
    int      nPotential;
    effect   eDam;
    object   oLastValid;
    effect   eStun = EffectLinkEffects(EffectVisualEffect(VFX_IMP_STUN),EffectStunned());

    //--------------------------------------------------------------------------
    // Calculate Damage Dice. 1d per 2 caster levels, max 5d
    //--------------------------------------------------------------------------
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);



    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_ELECTRICAL);

    int nNumDice = CasterLvl/2;
    if (nNumDice<1)
    {
        nNumDice = 1;
    }
    else if (nNumDice >5)
    {
        nNumDice = 5;
    }

    CasterLvl +=SPGetPenetr();

    //--------------------------------------------------------------------------
    // Loop through all targets
    //--------------------------------------------------------------------------

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            //------------------------------------------------------------------
            // Calculate delay until spell hits current target. If we are the
            // first target, the delay is the time until the spell hits us
            //------------------------------------------------------------------
            if (GetIsObjectValid(oLastValid))
            {
                   fDelay += 0.2f;
                   fDelay += GetDistanceBetweenLocations(GetLocation(oLastValid), GetLocation(oTarget))/20;
            }
            else
            {
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            }

            //------------------------------------------------------------------
            // If there was a previous target, draw a lightning beam between us
            // and iterate delay so it appears that the beam is jumping from
            // target to target
            //------------------------------------------------------------------
            if (GetIsObjectValid(oLastValid))
            {
                 eBeam = EffectBeam(VFX_BEAM_LIGHTNING, oLastValid, BODY_NODE_CHEST);
                 DelayCommand(fDelay,SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam,oTarget,1.5f));
            }

            if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
            {

                int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
                nPotential = MyMaximizeOrEmpower(6, nNumDice, nMetaMagic);
                nDamage    = PRCGetReflexAdjustedDamage(nPotential, oTarget, (GetSpellSaveDC() + nDC), SAVING_THROW_TYPE_ELECTRICITY);

                //--------------------------------------------------------------
                // If we failed the reflex save, we save vs will or are stunned
                // for one round
                //--------------------------------------------------------------
                if (nPotential == nDamage || (GetHasFeat(FEAT_IMPROVED_EVASION,oTarget) &&  nDamage == (nPotential/2)))
                {
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC() + nDC), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                    {
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eStun,oTarget, RoundsToSeconds(1)));
                    }

                }


                if (nDamage >0)
                {
                    eDam = EffectDamage(nDamage, EleDmg);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eStrike, oTarget));
                 }
            }

            //------------------------------------------------------------------
            // Store Target to make it appear that the lightning bolt is jumping
            // from target to target
            //------------------------------------------------------------------
            oLastValid = oTarget;

        }
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}


