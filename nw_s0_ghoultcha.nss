//::///////////////////////////////////////////////
//:: Ghoul Touch: On Enter
//:: NW_S0_GhoulTchA.nss
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

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
 ActionDoCommand(SetAllAoEInts(SPELL_GHOUL_TOUCH,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eAttack = EffectAttackDecrease(2);
    effect eDamage = EffectDamageDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link Effects
    effect eLink = EffectLinkEffects(eDamage, eSave);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eSkill);
    eLink = EffectLinkEffects(eLink, eDur);

    if(!GetIsReactionTypeFriendly(oTarget) || GetAreaOfEffectCreator() != oTarget)
    {
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget) && !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,GetAreaOfEffectCreator()))))
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2+d6()));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}


