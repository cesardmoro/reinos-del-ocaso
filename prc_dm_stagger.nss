#include "prc_inc_clsfunc"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
int nDam= GetCreatureDamage();
    if(nDam == -1 | 0)    {return;}
float fSecs = RoundsToSeconds(2);
float fDistance = GetDistanceToObject(GetSpellTargetObject());

effect eRun = EffectMovementSpeedIncrease(99);
effect eAtt = EffectAttackIncrease(2);
effect eAC  = EffectACDecrease(2, AC_NATURAL_BONUS);
effect eDam = EffectDamageIncrease(nDam);

//object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR);

int bTumbleCheckMade;
if( ( d20() + GetSkillRank(SKILL_TUMBLE) ) > 14)
    bTumbleCheckMade = TRUE;
else
    bTumbleCheckMade = FALSE;

//only allow the charge attack if the target is at least 10 feet away:
if(fDistance >= FeetToMeters(10.0))
    {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRun, OBJECT_SELF, fSecs);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAtt, OBJECT_SELF, fSecs);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, OBJECT_SELF, fSecs);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDam, OBJECT_SELF, fSecs);
    AssignCommand(OBJECT_SELF, DetermineCombatRound(GetSpellTargetObject()));
    AssignCommand(OBJECT_SELF, ActionAttack(GetSpellTargetObject()));

    if( (Random(10) + 1) > 5)//Posibility of Knocking down the oppenent:
        {DelayCommand(RoundsToSeconds(1) - 0.6, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), GetSpellTargetObject(), 5.0));}
    }
else
    {
    FloatingTextStringOnCreature("You are too close to the target", OBJECT_SELF);
    }

}
