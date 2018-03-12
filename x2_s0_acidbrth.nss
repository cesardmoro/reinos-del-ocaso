//::///////////////////////////////////////////////
//:: Mestil's Acid Breath
//:: X2_S0_AcidBrth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You breathe forth a cone of acidic droplets. The
// cone inflicts 1d6 points of acid damage per caster
// level (maximum 10d6).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov, 22 2002
//:://////////////////////////////////////////////

//float SpellDelay (object oTarget, int nShape);
//:: modified by mr_bumpkin Dec 4, 2003 for prc stuff
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


    //Declare major variables
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_ACID);

    int nCasterLevel = CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    //Limit Caster level for the purposes of damage.
    if (nCasterLevel > 10)
    {
        nCasterLevel = 10;
    }

     CasterLvl +=SPGetPenetr();

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the target and caster to delay the application of effects
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
            //Make SR check, and appropriate saving throw(s).
            if(!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay) && (oTarget != OBJECT_SELF))
            {
                int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
                //Detemine damage
                nDamage = d6(nCasterLevel);
                //Enter Metamagic conditions
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                    nDamage = 6 * nCasterLevel;//Damage is at max
                }
                else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
                //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC() + nDC), SAVING_THROW_TYPE_ACID);

                // Apply effects to the currently selected target.
                effect eAcid = EffectDamage(nDamage, EleDmg);
                effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
                if(nDamage > 0)
                {
                    //Apply delayed effects
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 8.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}


