//::///////////////////////////////////////////////
//:: Entangle
//:: NW_S0_EntangleC.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the AOE the target must make
    a reflex save or be entangled by vegitation
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
//::Updated Aug 14, 2003 Georg: removed some artifacts

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
 ActionDoCommand(SetAllAoEInts(SPELL_ENTANGLE,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    effect eHold = EffectEntangle();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    //Link Entangle and Hold effects
    effect eLink = EffectLinkEffects(eHold, eEntangle);
    object oCreator;
    int bValid;

    object aoeCreator = GetAreaOfEffectCreator();
    int CasterLvl = PRCGetCasterLevel(aoeCreator);

    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);


    object oTarget = GetFirstInPersistentObject();

    while(GetIsObjectValid(oTarget))
    {  // SpawnScriptDebugger();
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENTANGLE));
                //Make SR check
                if(!GetHasSpellEffect(SPELL_ENTANGLE, oTarget))
                {
                    if(!MyPRCResistSpell(aoeCreator, oTarget,nPenetr))
                    {
                        if (!GetIsSkillSuccessful(oTarget, SKILL_ESCAPE_ARTIST, 20)) {
                            //Make reflex save
                            if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,aoeCreator))))
                            {
                            //Apply linked effects
                               SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2),FALSE);
                            } else {
                               SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(50), oTarget, RoundsToSeconds(2),FALSE);
                            }
                        }
                    }
                }
            }
        }
        //Get next target in the AOE
        oTarget = GetNextInPersistentObject();
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
