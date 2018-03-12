int PRCDoRangedTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF);
int PRCDoMeleeTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF);

#include "prc_inc_sneak"
#include "inc_utility"
#include "prc_inc_combat"

int PRCDoRangedTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF)
{
    if(GetLocalInt(oCaster, "AttackHasHit"))
        return GetLocalInt(oCaster, "AttackHasHit");
    string sCacheName = "AttackHasHit_"+ObjectToString(oTarget);
    if(GetLocalInt(oCaster, sCacheName))
        return GetLocalInt(oCaster, sCacheName);
    int nResult = GetAttackRoll(oTarget, oCaster, OBJECT_INVALID, 0, 0, 0, nDisplayFeedback, 0.0, TOUCH_ATTACK_RANGED_SPELL);
    SetLocalInt(oCaster, sCacheName, nResult);
    DelayCommand(1.0, DeleteLocalInt(oCaster, sCacheName));
    return nResult;
}

int PRCDoMeleeTouchAttack(object oTarget, int nDisplayFeedback = TRUE, object oCaster = OBJECT_SELF)
{
    if(GetLocalInt(oCaster, "AttackHasHit"))
        return GetLocalInt(oCaster, "AttackHasHit");
    string sCacheName = "AttackHasHit_"+ObjectToString(oTarget);
    if(GetLocalInt(oCaster, sCacheName))
        return GetLocalInt(oCaster, sCacheName);
    int nResult = GetAttackRoll(oTarget, oCaster, OBJECT_INVALID, 0, 0,0,nDisplayFeedback, 0.0, TOUCH_ATTACK_MELEE_SPELL);
    SetLocalInt(oCaster, sCacheName, nResult);
    DelayCommand(1.0, DeleteLocalInt(oCaster, sCacheName));
    return nResult;
}

// return sneak attack damage for a spell
// requires caster, target, and spell damage type
int SpellSneakAttackDamage(object oCaster, object oTarget)
{
     int numDice = GetTotalSneakAttackDice(oCaster);

     if(numDice != 0 && GetCanSneakAttack(oTarget, oCaster) )
     {
          FloatingTextStringOnCreature("*Sneak Attack Spell*", oCaster, TRUE);
          return GetSneakAttackDamage(numDice);
     }
     else
     {
          return 0;
     }
}

// Applies damage from a ranged touch attack including critical damage and sneak attack damage
// the target to attack, the original damage ammount (will get doubled if critical)
// TouchAttackType  0 = melee, 1 = ranged  , 3 non-sneak melee, 4 non-sneak ranged
// DisplayFeedBack - default is true
int ApplyTouchAttackDamage(object oCaster, object oTarget, int iAttackRoll, int iDamage, int iDamageType, int bCanSneakAttack = TRUE)
{
     // perform critical
     if(iAttackRoll == 2)  iDamage *= 2;

     // add sneak attack damage if applicable
     if(bCanSneakAttack && !GetPRCSwitch(PRC_SPELL_SNEAK_DISABLE))
          iDamage += SpellSneakAttackDamage(oCaster, oTarget);

     // adds the bonus for spell bretrayal or spell strike for touch spells
     iDamage += ApplySpellBetrayalStrikeDamage(oTarget, oCaster);
     // apply damage
     if(iAttackRoll > 0)
     {
          effect eDamage = EffectDamage(iDamage, iDamageType);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
     }

     return iAttackRoll;
}

//routes to DoRacialSLA, but checks that the ray hits first
//not sure how this will work if the spell does multiple touch attack, hopefully that shouldnt apply
//this is Base DC, not total DC. SLAs are still spells, so spell focus should still apply.
void DoSpellRay(int nSpellID, int nCasterlevel = 0, int nTotalDC = 0)
{
    int nAttack = PRCDoRangedTouchAttack(PRCGetSpellTargetObject());
    if(nAttack)
    {
        ActionDoCommand(SetLocalInt(OBJECT_SELF, "AttackHasHit", nAttack)); //preserve crits
        DoRacialSLA(nSpellID, nCasterlevel, nTotalDC);
        ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "AttackHasHit"));
    }
}

//routes to DoRacialSLA, but checks that the rouch hits first
//not sure how this will work if the spell does multiple touch attack, hopefully that shouldnt apply
//this is Base DC, not total DC. SLAs are still spells, so spell focus should still apply.
void DoSpellMeleeTouch(int nSpellID, int nCasterlevel = 0, int nTotalDC = 0)
{
    int nAttack = PRCDoMeleeTouchAttack(PRCGetSpellTargetObject());
    if(nAttack)
    {
        ActionDoCommand(SetLocalInt(OBJECT_SELF, "AttackHasHit", nAttack)); //preserve crits
        DoRacialSLA(nSpellID, nCasterlevel, nTotalDC);
        ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "AttackHasHit"));
    }
}