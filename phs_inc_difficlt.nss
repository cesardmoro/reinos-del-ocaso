/*:://////////////////////////////////////////////
//:: Name Difficulty settings include
//:: FileName PHS_INC_Difficlt
//:://////////////////////////////////////////////
    Biowares scaling effects for now.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Get Difficulty Duration
// - If they are a PC, and the duration is over 3...
//   - (Very) Easy = 1/4th of the duration.
//   - Normal = 1/2th of the duration
// Scales for Confusion.
float PHS_GetScaledDuration(float fActualDuration, object oTarget);
// Get Scaled Effect
// - Works on PC's or Henchmen/familiars of a PC.
// - Frightened
//   - Very Easy = -2 Attack, Easy = -4 Attack.
// - Paralyze, Stun, Confuse
//   - Very Easy = Daze
// - Charm, Domination
//   - Change to Daze
effect PHS_GetScaledEffect(effect eStandard, object oTarget);

// Get Difficulty Duration
// - If they are a PC, and the duration is over 3...
//   - (Very) Easy = 1/4th of the duration.
//   - Normal = 1/2th of the duration
// Scales for Confusion.
float PHS_GetScaledDuration(float fActualDuration, object oTarget)
{
    int nDiff = GetGameDifficulty();
    float fNew = fActualDuration;
    // We do NOT scale durations for now.
/*    if(GetIsPC(oTarget) && fActualDuration > 3.0)
    {
        if(nDiff == GAME_DIFFICULTY_VERY_EASY || nDiff == GAME_DIFFICULTY_EASY)
        {
            nNew = fActualDuration / 4;
        }
        else if(nDiff == GAME_DIFFICULTY_NORMAL)
        {
            nNew = fActualDuration / 2;
        }
        if(fNew < 1.0)
        {
            fNew = 1.0;
        }
    } */
    return fNew;
}
// Get Scaled Effect
effect PHS_GetScaledEffect(effect eStandard, object oTarget)
{
    int nDiff = GetGameDifficulty();
    effect eNew = eStandard;
    object oMaster = GetMaster(oTarget);
    if(GetIsPC(oTarget) || (GetIsObjectValid(oMaster) && GetIsPC(oMaster)))
    {
        int nType = GetEffectType(eStandard);
        if(nType == EFFECT_TYPE_FRIGHTENED && nDiff == GAME_DIFFICULTY_VERY_EASY)
        {
            eNew = EffectAttackDecrease(-2);
            return eNew;
        }
        if(nType == EFFECT_TYPE_FRIGHTENED && nDiff == GAME_DIFFICULTY_EASY)
        {
            eNew = EffectAttackDecrease(-4);
            return eNew;
        }
        if(nDiff == GAME_DIFFICULTY_VERY_EASY &&
            (nType == EFFECT_TYPE_PARALYZE ||
             nType == EFFECT_TYPE_STUNNED ||
             nType == EFFECT_TYPE_CONFUSED))
        {
            eNew = EffectDazed();
            return eNew;
        }
        else if(nType == EFFECT_TYPE_CHARMED || nType == EFFECT_TYPE_DOMINATED)
        {
            eNew = EffectDazed();
            return eNew;
        }
    }
    return eNew;
}
