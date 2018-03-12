//::///////////////////////////////////////////////
//:: Ghoul Touch
//:: NW_S0_GhoulTch.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster attempts a touch attack on a target
    creature.  If successful creature must save
    or be paralyzed. Target exudes a stench that
    causes all enemies to save or be stricken with
    -2 Attack, Damage, Saves and Skill Checks for
    1d6+2 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 7, 2001
//:://////////////////////////////////////////////

/*  Georg 2003-09-11
    - Put in melee touch attack check, as the fixed attack bonus is now calculated correctly
 */

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
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


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGGHOUL);
    effect eParal = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);

    object oTarget = GetSpellTargetObject();
    int nDuration = d6()+2;
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nDuration = 8;//Damage is at max
    }
    else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
    }
    else if(CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOUL_TOUCH));
        //Make a touch attack to afflict target

       // GZ: * GetSpellCastItem() == OBJECT_INVALID is used to prevent feedback from showing up when used as OnHitCastSpell property
        if (TouchAttackMelee(oTarget,GetSpellCastItem() == OBJECT_INVALID)>0)
        {
            //SR and Saves
            if(!MyPRCResistSpell(OBJECT_SELF, oTarget) && !/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
            {
                //Create an instance of the AOE Object using the Apply Effect function
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oTarget), RoundsToSeconds(nDuration));
            }
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

