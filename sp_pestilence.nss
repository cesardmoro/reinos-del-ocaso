//::///////////////////////////////////////////////
//:: Pestilence
//:: sp_pestilence.nss
//:://////////////////////////////////////////////
/*
 Disease effect on target. The disease will spawn an AOE
 that will spread the disease for 24h from infection.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: December 25, 2004
//:://////////////////////////////////////////////


#include "spinc_common"

void main()
{
    //SpawnScriptDebugger();
    
SPSetSchool(SPELL_SCHOOL_NECROMANCY);
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
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLvl + SPGetPenetr(oCaster);
    int nDC = PRCGetSaveDC(oTarget, oCaster);
    
    effect eDisease = EffectDisease(DISEASE_PESTILENCE);
    effect eAoE = EffectAreaOfEffect(AOE_MOB_PESTILENCE);
    
    
    // Check for the disease component
    if(!GetHasEffect(EFFECT_TYPE_DISEASE, oCaster))
    {
        if(GetIsPC(oCaster))
        {
            SendMessageToPC(oCaster, "You need to to be diseased to cast this spell");
        }// end if - is oCaster a PC
    }// end if - caster isn't diseased
    else
    {
        //int nTouch = TouchAttackMelee(oTarget);
        
        // Check if the target is valid
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_PESTILENCE));
            
            //Make touch attack
            if(PRCDoMeleeTouchAttack(oTarget))
            {
                //Make sure the target is a living one
                if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT && MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {
                    //Make SR Check
                    if (!MyPRCResistSpell(oCaster, oTarget, nPenetr))
                    {
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DISEASE))
                        {
                            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget, 0.0f, FALSE, SPELL_PESTILENCE, nCasterLvl, oCaster);
                            SetLocalInt(oTarget, "SPELL_PESTILENCE_DC", nDC);
                            SetLocalInt(oTarget, "SPELL_PESTILENCE_CASTERLVL", nCasterLvl);
                            SetLocalInt(oTarget, "SPELL_PESTILENCE_SPELLPENETRATION", nPenetr);
                            SetLocalObject(oTarget, "SPELL_PESTILENCE_CASTER", oCaster);
                            SetLocalInt(oTarget, "SPELL_PESTILENCE_DO_ONCE", TRUE);
//                          DelayCommand(4.0f, DeleteLocalInt(oTarget, "SPELL_PESTILENCE_DO_ONCE"));
                            
                            // Delayed a bit. Seems like the presence of the disease effect may
                            // not register immediately, resulting in the AoE killing itself
                            // right away due to that check failing.
                            DelayCommand(0.4f, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAoE, oTarget, HoursToSeconds(24) /*+10*/, FALSE, SPELL_PESTILENCE, nCasterLvl, oCaster));
                }// end if - fort save
                    }// end if - spell resistance
                }//end if - only living targets
            }// end if - touch attack
        }// end if - is the target valid
    }// end else - the caster is diseased
// Getting rid of the integer used to hold the spells spell school
SPSetSchool();
}