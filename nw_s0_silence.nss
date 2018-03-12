//::///////////////////////////////////////////////
//:: Silence
//:: NW_S0_Silence.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target is surrounded by a zone of silence
    that allows them to move without sound.  Spell
    casters caught in this area will be unable to cast
    spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"


#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
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
    effect eAOE = EffectAreaOfEffect(AOE_MOB_SILENCE);
    
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator(),CasterLvl);

    int nDuration = CasterLvl;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration *2;    //Duration is +100%
    }

    if(!GetIsFriend(oTarget))
    {
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,OBJECT_SELF))))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE));

                //Create an instance of the AOE Object using the Apply Effect function
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, RoundsToSeconds(nDuration));
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SILENCE, FALSE));
        //Create an instance of the AOE Object using the Apply Effect function
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, RoundsToSeconds(nDuration));
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

