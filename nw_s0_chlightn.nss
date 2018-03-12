//::///////////////////////////////////////////////
//:: Chain Lightning
//:: NW_S0_ChLightn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The primary target is struck with 1d6 per caster,
    1/2 with a reflex save.  1 secondary target per
    level is struck for 1d6 / 2 caster levels.  No
    repeat targets can be chosen.
*/
//:://////////////////////////////////////////////
//:: Created By: Brennon Holmes
//:: Created On:  March 8, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 26, 2001
//:: Update Pass By: Preston W, On: July 26, 2001

/*
bugfix by Kovi 2002.07.28
- successful saving throw and (improved) evasion was ignored for
 secondary targets,
- all secondary targets suffered exactly the same damage
2002.08.25
- primary target was not effected
*/


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

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
    int nCasterLevel = CasterLvl;
    //Limit caster level
    // June 2/04 - Bugfix: Cap the level BEFORE the damage calculation, not after. Doh.
    if (nCasterLevel > 20)
    {
        nCasterLevel = 20;
    }

    int nDamage = d6(nCasterLevel);
    int nDamStrike;
    int nNumAffected = 0;
    int nMetaMagic = GetMetaMagicFeat();
    //Declare lightning effect connected the casters hands
    effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);;
    effect eVis  = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
    effect eDamage;
    object oFirstTarget = GetSpellTargetObject();
    object oHolder;
    object oTarget;
    location lSpellLocation;

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nDamage = 6 * nCasterLevel;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nDamage = nDamage + (nDamage/2); //Damage/is +50%
    }

    CasterLvl +=SPGetPenetr();

    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_ELECTRICAL);

    //Damage the initial target
    if (spellsIsTarget(oFirstTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oFirstTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
        //Make an SR Check
        if (!MyPRCResistSpell(OBJECT_SELF, oFirstTarget,CasterLvl))
        {
           int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
            //Adjust damage via Reflex Save or Evasion or Improved Evasion
            nDamStrike = PRCGetReflexAdjustedDamage(nDamage, oFirstTarget, (GetSpellSaveDC()+ nDC), SPGetElementalSavingThrowType(SAVING_THROW_TYPE_ELECTRICITY));
            //Set the damage effect for the first target
            eDamage = EffectDamage(nDamStrike, EleDmg);
            //Apply damage to the first target and the VFX impact.
            if(nDamStrike > 0)
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oFirstTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oFirstTarget);
            }
        }
    }
    //Apply the lightning stream effect to the first target, connecting it with the caster
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oFirstTarget,0.5,FALSE);


    //Reinitialize the lightning effect so that it travels from the first target to the next target
    eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oFirstTarget, BODY_NODE_CHEST);


    float fDelay = 0.2;
    int nCnt = 0;


    // *
    // * Secondary Targets
    // *


    //Get the first target in the spell shape
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oTarget) && nCnt < nCasterLevel)
    {
        //Make sure the caster's faction is not hit and the first target is not hit
        if (oTarget != oFirstTarget && spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Connect the new lightning stream to the older target and the new target
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,0.5,FALSE));

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHAIN_LIGHTNING));
            //Do an SR check
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
            {
                int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
                nDamage = d6(nCasterLevel) ;

                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                    nDamage = 6 * nCasterLevel;//Damage is at max
                }
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                    nDamage = nDamage + (nDamage/2); //Damage/is +50%
                }
                //Adjust damage via Reflex Save or Evasion or Improved Evasion
                nDamStrike = PRCGetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC() + nDC), SAVING_THROW_TYPE_ELECTRICITY);
                //Apply the damage and VFX impact to the current target
                eDamage = EffectDamage(nDamStrike /2, EleDmg);
                if(nDamStrike > 0) //age > 0)
                {
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                }
            }
            oHolder = oTarget;

            //change the currect holder of the lightning stream to the current target
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {
            eLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
            }
            else
            {
                // * April 2003 trying to make sure beams originate correctly
                effect eNewLightning = EffectBeam(VFX_BEAM_LIGHTNING, oHolder, BODY_NODE_CHEST);
                if(GetIsEffectValid(eNewLightning))
                {
                    eLightning =  eNewLightning;
                }
            }

            fDelay = fDelay + 0.1f;
        }
        //Count the number of targets that have been hit.
        if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
        {
            nCnt++;
        }

        // April 2003: Setting the new origin for the beam
       // oFirstTarget = oTarget;

        //Get the next target in the shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oFirstTarget), TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
      }


 }
