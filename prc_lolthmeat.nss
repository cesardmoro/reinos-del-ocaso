//::///////////////////////////////////////////////
//:: Name Lolth's Meat
//:: FileName prc_lolthmeat
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Lolth's Meat feat
*/
//:://////////////////////////////////////////////
//:: Created By: PsychicToaster
//:: Created On: 7-31-04
//:://////////////////////////////////////////////

#include "prc_feat_const"

void main()
{

object oPC  = OBJECT_SELF;

if(GetHasFeat(FEAT_LOLTHS_MEAT))
    {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(1, ATTACK_BONUS_MISC), oPC, 24.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(1, DAMAGE_TYPE_DIVINE), oPC, 24.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_ALL), oPC, 24.0);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_EVIL_HELP), oPC);
    }

}
