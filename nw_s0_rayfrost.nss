 //::///////////////////////////////////////////////
//:: Ray of Frost
//:: [NW_S0_RayFrost.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the caster succeeds at a ranged touch attack
    the target takes 1d4 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: feb 4, 2001
//:://////////////////////////////////////////////
//:: Bug Fix: Andrew Nobbs, April 17, 2003
//:: Notes: Took out ranged attack roll.
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
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
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDam = d4(1) + 1;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);

    nCasterLevel +=SPGetPenetr();

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));
        eRay = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);
        //Make SR Check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nCasterLevel))
        {
            //Enter Metamagic conditions
            if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
            {
                nDam = 5 ;//Damage is at max
            }
            else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
            {
                nDam = nDam + nDam/2; //Damage/Healing is +50%
            }
            //Set damage effect
            eDam = EffectDamage(nDam, SPGetElementalDamageType(DAMAGE_TYPE_COLD));
            //Apply the VFX impact and damage effect
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
    }
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7,FALSE);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school

}
