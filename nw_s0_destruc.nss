//::///////////////////////////////////////////////
//:: Destruction
//:: NW_S0_Destruc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target creature is destroyed if it fails a
    Fort save, otherwise it takes 10d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    int nDamage;
    effect eDeath = EffectDeath();
    effect eDam;
    effect eVis = EffectVisualEffect(234);
    
    
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    CasterLvl +=SPGetPenetr();

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DESTRUCTION));
        //Make SR check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl))
        {
            //Make a saving throw check
            if(!/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF))))
            {
                DeathlessFrenzyCheck(oTarget);
                
                //Apply the VFX impact and effects
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
            }
            else
            {
                nDamage = d6(10);
                //Enter Metamagic conditions
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                    nDamage = 60;//Damage is at max
                }
                else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                    nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            }
            //Apply VFX impact
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
