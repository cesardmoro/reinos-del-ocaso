//::///////////////////////////////////////////////
//:: Doom
//:: NW_S0_Doom.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the target fails a save they recieve a -2
    penalty to all saves, attack rolls, damage and
    skill checks for the duration of the spell.

    July 22 2002 (BK): Made it mind affecting.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

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
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eLink = CreateDoomEffectsLink();

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nLevel = CasterLvl;
    int nPenetr= CasterLvl + SPGetPenetr();
    
    int nMetaMagic = GetMetaMagicFeat();
    //Meta-Magic checks
    if(CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nLevel *= 2;
    }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOOM));
        //Spell Resistance and Saving throw

        //* GZ Engine fix for mind affecting spell

        int nResult = WillSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS);
        if (nResult == 2)
        {
            if (GetIsPC(OBJECT_SELF)) // only display immune feedback for PCs
            {
                FloatingTextStrRefOnCreature(84525, oTarget,FALSE); // * Target Immune
            }
            return;
        }
	  else if (nResult == 1)
	  {
		return;
	  }

        nResult = (nResult || MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr));
        if (!nResult)
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(nLevel),TRUE,-1,CasterLvl);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

