/*
    Mass Staredown
    All Creatures around the Samurai must pass an
    opposed Intimidate Check or suffer penalites
*/

#include "X2_I0_SPELLS"
#include "prc_class_const"
void main()
{
    //Declare major variables
    object oTarget;
    object oPC = OBJECT_SELF;

    int nDuration = 2;

    if(GetLevelByClass(CLASS_TYPE_CW_SAMURAI,oPC) >= 14)
    {
     nDuration = 5;
    }


    int iPCCha = GetAbilityModifier(ABILITY_CHARISMA,oPC);
    int iTACha = GetAbilityModifier(ABILITY_CHARISMA,oTarget);

    int iPCRoll = GetSkillRank(SKILL_INTIMIDATE,oPC) + d20();
    int iTARoll = GetSkillRank(SKILL_INTIMIDATE,oTarget) + d20();

    effect eDam = EffectAttackDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS,2);
    effect eLink = EffectLinkEffects(eDam,eSave);
    eLink = EffectLinkEffects(eLink,eSkill);


    //Determine enemies in the radius around the samurai
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
           //Make Intimidate Check
           if(iPCRoll > iTARoll)
            {
             ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(nDuration));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }

}
