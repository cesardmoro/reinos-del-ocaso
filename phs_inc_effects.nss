/*:://////////////////////////////////////////////
//:: Name Effect's include
//:: FileName PHS_INC_EFFECTS
//:://////////////////////////////////////////////
    This holds all effect creating functions.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Effect returns

// Linked effect of Shaken - fear induced.
// * -2 to attack, Damage, Saves and Skills.
effect PHS_CreateShakenEffectsLink();

// Returns a haste effect as par 3.5E
// +1 AC, +1 attack bonus, +1 Attack at full BAB, +50% move speed (30 feet in 3.5)
effect PHS_CreateHasteEffect();
// Returns a slow effect as par 3.5E
// -1 AC, -1 attack bonus, -1 Attack at full BAB, -50% move speed (30 feet in 3.5)
// - Also no attack decreases (we have no "Actions" in rounds ETC)
effect PHS_CreateSlowEffect();

// Creates a linked effects of all the spells to iBonus.
// - Useful for "luck"
effect PHS_AllSkillsIncreaseEffect(int iBonus);
// Creates a linked effects of all the spells to iPenalty.
// - Useful for "unlucky"
effect PHS_AllSkillsDecreaseEffect(int iPenalty);
// Returns an EffectCurse specifically for iAbility with iPenalty.
// * You can only (via. game limitations) apply 1 curse at a time.
effect PHS_SpecificAbilityCurse(int iAbility, int iPenalty);

// Returns -1 Attack, -1 Spot and -1 Search.
effect PHS_DazzleEffectLink();

// Linked effect of Shaken - fear induced.
// * -2 to attack, Damage, Saves and Skills.
effect PHS_CreateShakenEffectsLink()
{
    //Declare major variables
    effect eSaves = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eAttack = EffectAttackDecrease(2);
    effect eDamage = EffectDamageDecrease(2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSaves);
    eLink = EffectLinkEffects(eLink, eSkill);
    eLink = EffectLinkEffects(eLink, eDur);

    return eLink;
}

// Returns a haste effect as par 3.5E
// +1 AC, +1 attack bonus, +1 Attack at full BAB, +50% move speed (30 feet in 3.5)
effect PHS_CreateHasteEffect()
{
    effect eMove = EffectMovementSpeedIncrease(50);
    effect eAttackBonus = EffectAttackIncrease(1);
    effect eAttackExtra = EffectModifyAttacks(1);
    effect eAC = EffectACIncrease(1, AC_DODGE_BONUS);
    // Link
    effect eLink = EffectLinkEffects(eMove, eAttackBonus);
    eLink = EffectLinkEffects(eLink, eAttackExtra);
    eLink = EffectLinkEffects(eLink, eAC);

    return eLink;
}
// Returns a slow effect as par 3.5E
// -1 AC, -1 attack bonus, -1 Attack at full BAB, -50% move speed (30 feet in 3.5)
// - Also no attack decreases (we have no "Actions" in rounds ETC)
effect PHS_CreateSlowEffect()
{
    effect eMove = EffectMovementSpeedDecrease(50);
    effect eAttackBonus = EffectAttackDecrease(1);
    effect eAC = EffectACDecrease(1, AC_DODGE_BONUS);
    // Link
    effect eLink = EffectLinkEffects(eMove, eAttackBonus);
    eLink = EffectLinkEffects(eLink, eAC);

    return eLink;
}

effect PHS_AllSkillsIncreaseEffect(int iBonus)
{
    effect eReturnLink;
    effect eSkill;
    int iCnt;
    // Loop all known skills
    /*
int SKILL_ANIMAL_EMPATHY   = 0;
...
int SKILL_CRAFT_WEAPON     = 26;
    */
    for(iCnt = 0; iCnt <= 26; iCnt++)
    {
        // Create new skill bonus effect
        eSkill = EffectSkillIncrease(iCnt, iBonus);
        // Link effects
        eReturnLink = EffectLinkEffects(eSkill, eReturnLink);
    }
    return eReturnLink;
}
// Creates a linked effects of all the spells to iPenalty.
// - Useful for "unlucky"
effect PHS_AllSkillsDecreaseEffect(int iPenalty)
{
    effect eReturnLink;
    effect eSkill;
    int iCnt;
    // Loop all known skills - see above
    for(iCnt = 0; iCnt <= 26; iCnt++)
    {
        // Create new skill bonus effect
        eSkill = EffectSkillDecrease(iCnt, iPenalty);
        // Link effects
        eReturnLink = EffectLinkEffects(eSkill, eReturnLink);
    }
    return eReturnLink;
}

// Returns an EffectCurse specifically for iAbility with iPenalty.
// * You can only (via. game limitations) apply 1 curse at a time.
effect PHS_SpecificAbilityCurse(int iAbility, int iPenalty)
{
    effect eReturn;

    switch(iAbility)
    {
        case ABILITY_CHARISMA:     eReturn = EffectCurse(0, 0, 0, 0, 0, iPenalty); break;
        case ABILITY_CONSTITUTION: eReturn = EffectCurse(0, 0, iPenalty, 0, 0, 0); break;
        case ABILITY_DEXTERITY:    eReturn = EffectCurse(0, iPenalty, 0, 0, 0, 0); break;
        case ABILITY_INTELLIGENCE: eReturn = EffectCurse(0, 0, 0, iPenalty, 0, 0); break;
        case ABILITY_STRENGTH:     eReturn = EffectCurse(iPenalty, 0, 0, 0, 0, 0); break;
        case ABILITY_WISDOM:       eReturn = EffectCurse(0, 0, 0, 0, iPenalty, 0); break;
        // Default = Strength
        default:                   eReturn = EffectCurse(iPenalty, 0, 0, 0, 0, 0); break;
    }
    return eReturn;
}

// Returns -1 Attack, -1 Spot and -1 Search.
effect PHS_DazzleEffectLink()
{
    effect eDazzle1 = EffectAttackDecrease(1);
    effect eDazzle2 = EffectSkillDecrease(SKILL_SPOT, 1);
    effect eDazzle3 = EffectSkillDecrease(SKILL_SEARCH, 1);

    effect eReturn = EffectLinkEffects(eDazzle1, eDazzle2);
    eReturn = EffectLinkEffects(eReturn, eDazzle3);

    return eReturn;
}
