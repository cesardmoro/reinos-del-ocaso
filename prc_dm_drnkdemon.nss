#include "prc_inc_clsfunc"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
object oPC = OBJECT_SELF;

//see if player is already Drunk Like a Demon:
if(GetLocalInt(oPC, "DRUNKEN_MASTER_IS_DRUNK_LIKE_A_DEMON") != 0)
    {
    // PC already has Drink Like a Demon effects, exit:
    FloatingTextStringOnCreature("You're already Drunk Like a Demon", oPC);
    return;
    }

float fSec = HoursToSeconds(1);

// Set the int so effects don't stack:
SetLocalInt(oPC, "DRUNKEN_MASTER_IS_DRUNK_LIKE_A_DEMON", 1);
DelayCommand(fSec, SetLocalInt(oPC, "DRUNKEN_MASTER_IS_DRUNK_LIKE_A_DEMON", 0));

// A Drunken Master has had a drink. Add effects:
effect eWis = EffectAbilityDecrease(ABILITY_WISDOM, 1);
effect eInt = EffectAbilityDecrease(ABILITY_INTELLIGENCE, 1);
effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 1);

effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 1);
effect eCns = EffectAbilityIncrease(ABILITY_CONSTITUTION, 1);

effect eVFX2 = EffectVisualEffect(VFX_DUR_BLUR);

//save info prior to lowering effects:
int nReflexSave = GetReflexSavingThrow(oPC);
int nTumble = GetSkillRank(SKILL_TUMBLE);
int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY);
int nRSAfter, nTumbleAfter, nDexModAfter;

//Apply the major bonuses:
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWis, oPC, fSec);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInt, oPC, fSec);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oPC, fSec);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStr, oPC, fSec);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCns, oPC, fSec);

//Apply VFX's
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX2, oPC, fSec);

//run checks to see if Reflex Saving Throw, Tumble and Dex Modifier have been changed:
nRSAfter = GetReflexSavingThrow(oPC);
nTumbleAfter = GetSkillRank(SKILL_TUMBLE);
nDexModAfter = GetAbilityModifier(ABILITY_DEXTERITY);

if(nDexModAfter < nDexMod)
    {ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(nDexMod - nDexModAfter), oPC, fSec);}
if(nRSAfter < nReflexSave)
    {ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_REFLEX, nReflexSave - nRSAfter), oPC, fSec);}
if(nTumbleAfter < nTumble)
    {ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_TUMBLE, nTumble - nTumbleAfter), oPC, fSec);}

FloatingTextStringOnCreature("You are Drunk Like a Demon", oPC);
}
