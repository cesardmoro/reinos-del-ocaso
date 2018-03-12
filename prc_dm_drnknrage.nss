#include "prc_inc_clsfunc"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
object oPC = OBJECT_SELF;

//see if player already has rage effects from another class:
if (GetHasSpellEffect(307, oPC))
{
    FloatingTextStringOnCreature("You are already raging from another class ability.", oPC);
    return;
}

//see if player is already in a drunken rage:
if(GetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE") != 0)
    {
    FloatingTextStringOnCreature("You are already in a Drunken Rage", oPC);
    return;
    }

float fSec;

if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) > 9)
    {
    // Set duration to 3 hours:
    fSec = HoursToSeconds(3);
    SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 1);
    DelayCommand(fSec, SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0));
    }
else
    {
    // Otherwise set duration to 1 hour:
    fSec = HoursToSeconds(1);
    SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 1);
    DelayCommand(fSec, SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0));
    }

//Bonuses:
effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
effect eCst = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
effect eWillSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, 2);

//Penalties:
effect eAC = EffectACDecrease(2);

//Visual Effects:
effect eVFX2 = EffectVisualEffect(VFX_DUR_BLUR);
effect eVFX3  = EffectVisualEffect(VFX_DUR_AURA_FIRE);

effect eLink;

eLink = EffectLinkEffects(eStr, eCst);
eLink = EffectLinkEffects(eLink, eWillSave);
eLink = EffectLinkEffects(eLink, eAC);
eLink = EffectLinkEffects(eLink, eVFX2);
eLink = EffectLinkEffects(eLink, eVFX3);

eLink = ExtraordinaryEffect(eLink);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, fSec);

FloatingTextStringOnCreature("Drunken Rage Activated", oPC);
}
