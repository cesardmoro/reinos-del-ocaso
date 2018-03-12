/*:://////////////////////////////////////////////
//:: Name Spell Turning Include
//:: FileName PHS_INC_Turning
//:://////////////////////////////////////////////
    This includes the functions to let spells turn back from the target
    to the caster!

    From 3.5 rules:

    Spell Turning
    Abjuration
    Level: Luck 7, Magic 7, Sor/Wiz 7
    Components: V, S, M/DF
    Casting Time: 1 standard action
    Range: Personal
    Target: You
    Duration: Until expended or 10 min./level

    Spells and spell-like effects targeted on you are turned back upon the
    original caster. The abjuration turns only spells that have you as a target.
    Effect and area spells are not affected. Spell turning also fails to stop
    touch range spells.

    From seven to ten (1d4+6) spell levels are affected by the turning. The
    exact number is rolled secretly.

    When you are targeted by a spell of higher level than the amount of spell
    turning you have left, that spell is partially turned. The subtract the
    amount of spell turning left from the spell level of the incoming spell,
    then divide the result by the spell level of the incoming spell to see what
    fraction of the effect gets through. For damaging spells, you and the caster
    each take a fraction of the damage. For nondamaging spells, each of you has
    a proportional chance to be affected.

    If you and a spellcasting attacker are both warded by spell turning effects
    in operation, a resonating field is created.

    Roll randomly to determine the result.

    d%          Effect
    01-70       Spell drains away without effect.
    71-80       Spell affects both of you equally at full effect.
    81-97       Both turning effects are rendered nonfunctional for 1d4 minutes.
    98-100      Both of you go through a rift into another plane.

    Arcane Material Component: A small silver mirror.

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

// Note: Need to complete

const string PHS_SPELL_TURNING_TEMP_OFF = "PHS_SPELL_TURNING_TEMP_OFF";
const string PHS_SPELL_TURNING_AMOUNT   = "PHS_SPELL_TURNING_AMOUNT";
const string PHS_RIFT_TARGET            = "PHS_RIFT_TARGET";
#include "PHS_INC_CONSTANT"

// This checks for the spell "Spell Turning" and does a check
// based on it. Each spell has to be done on a case-by-case basis.
// It will return:
// 0 = No effect
// 1 = Spell drains away without effect.
// 2 = Spell affects both of you equally at full effect.
// 3 = Both turning effects are rendered nonfunctional for 1d4 minutes.
// 4 = Both of you go through a rift into another plane.
// 5 = If oCaster and oTarget have turning effects, a resonating field is created.
// NOTE: 3 and 4 do thier effects automatically. It is automatically decreased.
int PHS_SpellTurningCheck(object oCaster, object oTarget, int iSpellLevel, float fDelay = 0.0);

// Remove all effects from J_SPELL_SPELL_TURNING
void PHS_RemoveSpellTurning(object oTarget);

// Sends both players to the rift, IF THERE IS ONE.
// * TRUE if they are moved to the rift.
int PHS_MoveToRift(object oCaster, object oTarget);

// Does a resonating field.
// - What IS one!?
void PHS_ResonatingField(object oCaster, object oTarget);

// This checks for the spell "Spell Turning" and does a check
// based on it. Each spell has to be done on a case-by-case basis.
// It will return:
// 0 = No effect
// 1 = Spell drains away without effect.
// 2 = Spell affects both of you equally at full effect.
// 3 = Both turning effects are rendered nonfunctional for 1d4 minutes.
// 4 = Both of you go through a rift into another plane.
// 5 = If oCaster and oTarget have turning effects, a resonating field is created.
// NOTE: 3 and 4 do thier effects automatically. It is automatically decreased.
int PHS_SpellTurningCheck(object oCaster, object oTarget, int iSpellLevel, float fDelay = 0.0)
{
    // Default: No effect
    int iReturn = FALSE;
    int iDice, iTurnPower;

    // Does the target have the effects
    if(GetHasSpellEffect(PHS_SPELL_SPELL_TURNING, oTarget) &&
       !GetLocalInt(oTarget, PHS_SPELL_TURNING_TEMP_OFF))
    {
        // We first check if they already have spell turning too (and it is
        // activated) If so, return 5.
        if(GetHasSpellEffect(PHS_SPELL_SPELL_TURNING, oCaster) &&
          !GetLocalInt(oCaster, PHS_SPELL_TURNING_TEMP_OFF))
        {
            PHS_ResonatingField(oCaster, oTarget);
            return 5;
        }

        // Only reduce if spell level is over 0 (Cantrips don't affect it!)
        if(iSpellLevel > 0)
        {
            // Reduce the amount by the spell level, remove if under the
            // amount left.
            iTurnPower = GetLocalInt(oTarget, PHS_SPELL_TURNING_AMOUNT);
            // Take spell level
            iTurnPower -= iSpellLevel;
            // If it is lower then 1, we remove it, else set it.
            if(iTurnPower < 1)
            {
                PHS_RemoveSpellTurning(oTarget);
            }
            else
            {
                SetLocalInt(oTarget, PHS_SPELL_TURNING_AMOUNT, iTurnPower);
            }
        }
        // Resonating fields!

        // If so, roll a dice!
        iDice = d100();
/*
    d%          Effect
    01-70       Spell drains away without effect.
    71-80       Spell affects both of you equally at full effect.
    81-97       Both turning effects are rendered nonfunctional for 1d4 minutes.
    98-100      Both of you go through a rift into another plane.
*/
        effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
        // 1-70 = Spell drains away without effect.
        if(iDice <= 70)
        {
            // More delay off. Improves how it looks.
            if(fDelay > 0.5)
            {
                fDelay -= 0.1;
            }
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
            iReturn = 1;
        }
        // 71-80 = Spell affects both of you equally at full effect.
        else if(iDice <= 80)
        {
            iReturn = 2;
        }
        // 81-97 = Both turning effects are rendered nonfunctional for 1d4 minutes.
        else if(iDice <= 97)
        {
            int iMin = d4();
            SendMessageToPC(oTarget, "Your turning mantal turns off for " + IntToString(iMin) + "!");
            SetLocalInt(oTarget, PHS_SPELL_TURNING_TEMP_OFF, TRUE);
            DelayCommand(TurnsToSeconds(iMin), DeleteLocalInt(oTarget, PHS_SPELL_TURNING_TEMP_OFF));
            iReturn = 3;
        }
        // 98-100 = Both of you go through a rift into another plane.
        else
        {
            PHS_MoveToRift(oCaster, oTarget);
            iReturn = 4;
        }
    }
    // Return the result
    return iReturn;
}

// Remove all effects from J_SPELL_SPELL_TURNING
void PHS_RemoveSpellTurning(object oTarget)
{
    //Declare major variables
    effect  eCheck = GetFirstEffect(oTarget);;
    //Search through the valid effects on the target.
    while(GetIsEffectValid(eCheck))
    {
        //If the effect was created by the spell then remove it
        if(GetEffectSpellId(eCheck) == PHS_SPELL_SPELL_TURNING)
        {
            RemoveEffect(oTarget, eCheck);
        }
        //Get next effect on the target
        eCheck = GetNextEffect(oTarget);
    }
}

// Sends both players to the rift, IF THERE IS ONE.
// * TRUE if they are moved to the rift.
int PHS_MoveToRift(object oCaster, object oTarget)
{
    object oWP = GetObjectByTag(PHS_RIFT_TARGET);
    if(GetIsObjectValid(oWP))
    {
        location lWP = GetLocation(oWP);
        // Move the caster
        AssignCommand(oCaster, ClearAllActions());
        AssignCommand(oCaster, JumpToLocation(lWP));
        // Move the target
        AssignCommand(oTarget, ClearAllActions());
        AssignCommand(oTarget, JumpToLocation(lWP));
        return TRUE;
    }
    return FALSE;
}

// Does a resonating field.
void PHS_ResonatingField(object oCaster, object oTarget)
{
    int iInt;
}
