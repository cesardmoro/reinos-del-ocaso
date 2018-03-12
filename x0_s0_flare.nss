//::///////////////////////////////////////////////
//:: Flare
//:: [X0_S0_Flare.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature hit by ray loses 1 to attack rolls.

    DURATION: 10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

   if (GetHasFeat(FEAT_SHADOWWEAVE,OBJECT_SELF)) return;
   
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
    object oTarget = GetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nCasterLevel = CasterLvl + SPGetPenetr();

    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 416));

       // * Apply the hit effect so player knows something happened
       SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);


        //Make SR Check
        if ((!MyPRCResistSpell(OBJECT_SELF, oTarget,nCasterLevel)) &&  (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,OBJECT_SELF))) == FALSE) )
        {
            //Set damage effect
            effect eBad = EffectAttackDecrease(1);
            //Apply the VFX impact and damage effect
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds(10),TRUE,-1,CasterLvl);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}


