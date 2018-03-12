//::///////////////////////////////////////////////
//:: Stonehold
//:: X2_S0_StneholdC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an area of effect that will cover the
    creature with a stone shell holding them in
    place.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: May 04, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
ActionDoCommand(SetAllAoEInts(SPELL_STONEHOLD,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nRounds;
    int nMetaMagic = GetMetaMagicFeat();
    effect eHold = EffectParalyze();
    effect eDur = EffectVisualEffect(476 );
    eHold = EffectLinkEffects(eDur, eHold);
    effect eFind;
    object oTarget;
    object oCreator;
    float fDelay;

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail.
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }
    
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());
   

    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STONEHOLD));
            if (!GetHasSpellEffect(SPELL_STONEHOLD,oTarget))
            {
                if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
                {
                    int nDC = GetChangesToSaveDC(oTarget,GetAreaOfEffectCreator());
                    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC() + nDC) , SAVING_THROW_TYPE_MIND_SPELLS))
                    {
                       nRounds = MyMaximizeOrEmpower(6, 1, nMetaMagic);
                       fDelay = GetRandomDelay(0.75, 1.75);
                       DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHold, oTarget, RoundsToSeconds(nRounds),FALSE));
                    }
                    else
                    {
                        eFind = GetFirstEffect(oTarget);
                        int bDone = FALSE ;
                        while (GetIsEffectValid(eFind) && !bDone)
                        {
                                oCreator = GetEffectCreator(eFind);
                                if(oCreator == GetAreaOfEffectCreator())
                                {
                                    RemoveEffect(oTarget, eFind);
                                    bDone = TRUE;
                                }
                            eFind = GetNextEffect(oTarget);
                        }
                    }
                }
            }
        }
        oTarget = GetNextInPersistentObject();
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
