//::///////////////////////////////////////////////
//:: Flame Strike
//:: NW_S0_FlmStrike
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A flame strike is a vertical column of divine fire
// roaring downward. The spell deals 1d6 points of
// damage per level, to a maximum of 15d6. Half the
// damage is fire damage, but the rest of the damage
// results directly from divine power and is therefore
// not subject to protection from elements (fire),
// fire shield (chill shield), etc.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 19, 2000
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
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
  object oTarget;


    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);



    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_FIRE);

  int nCasterLvl = CasterLvl;
  int nDamage, nDamage2;
  int nMetaMagic = GetMetaMagicFeat();
  effect eStrike = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_FIRE);
  effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
  effect eHoly;
  effect eFire;
  //Limit caster level for the purposes of determining damage.
  if (nCasterLvl > 15)
  {
    nCasterLvl = 15;
  }

  CasterLvl +=SPGetPenetr();

  //Declare the spell shape, size and the location.  Capture the first target object in the shape.
  oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation(), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_DOOR);
  //Apply the location impact visual to the caster location instead of caster target creature.
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, GetSpellTargetLocation());
  //Cycle through the targets within the spell shape until an invalid object is captured.
  while ( GetIsObjectValid(oTarget) )
  {

            //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FLAME_STRIKE));
           //Make SR check, and appropriate saving throw(s).
           if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, 0.6))
           {
                int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
                nDamage =  d6(nCasterLvl);
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                     nDamage = 6 * nCasterLvl;
                }
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                      nDamage = nDamage + (nDamage/2);
                }
                //Adjust the damage based on Reflex Save, Evasion and Improved Evasion
                nDamage2 = PRCGetReflexAdjustedDamage(nDamage/2, oTarget, (GetSpellSaveDC()+ nDC), SAVING_THROW_TYPE_DIVINE);
                nDamage = PRCGetReflexAdjustedDamage(nDamage/2, oTarget, (GetSpellSaveDC()+ nDC), SAVING_THROW_TYPE_FIRE);
                //Make a faction check so that only enemies receieve the full brunt of the damage.
                if(!GetIsFriend(oTarget))
                {
                    eHoly =  EffectDamage(nDamage2,DAMAGE_TYPE_DIVINE);
                    DelayCommand(0.6, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHoly, oTarget));
                }
                // Apply effects to the currently selected target.
                eFire =  EffectDamage(nDamage,EleDmg);
                if(nDamage > 0)
                {
                    DelayCommand(0.6, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eFire, oTarget));
                    DelayCommand(0.6, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }

        //Select the next target within the spell shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM,GetSpellTargetLocation(), FALSE, OBJECT_TYPE_CREATURE|OBJECT_TYPE_PLACEABLE|OBJECT_TYPE_DOOR);
    }



DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
