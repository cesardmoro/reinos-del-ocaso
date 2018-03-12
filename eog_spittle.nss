
//:////////////////////////////////////
//:  Eye of Gruumsh - Blinding Spittle
//:  ranged touch attack
//:  Reflex save (DC 10 + Eye of Gruumsh level + EoG Con bonus)
//:  Causes blindness
//:////////////////////////////////////

#include "prc_class_const"
#include "prc_alterations"

void CheckBlindness(object oTarget)
{
    if (GetIsDead(oTarget) || !GetIsFighting(oTarget) && GetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget) )
    {
         RemoveSpecificEffect(EFFECT_TYPE_BLINDNESS, oTarget);
    }
    else if(GetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget) )
    {
         DelayCommand(6.0, CheckBlindness(oTarget) );
    }
}

void main()
{
     object oCaster = OBJECT_SELF;
     object oTarget = PRCGetSpellTargetObject();
     int iTargetRace = MyPRCGetRacialType(oTarget);
     int iBeholder = iTargetRace == RACIAL_TYPE_ABERRATION && GetHasSpell(710, oTarget) && GetHasSpell(711, oTarget) && GetHasSpell(712, oTarget);


     ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_ACID_S), oTarget);

     if(GetDistanceBetween(oCaster, oTarget) < 6.2 &&  // has to be within 20 ft.
        iTargetRace != RACIAL_TYPE_OOZE &&             // has to use sight to attack
        iTargetRace != RACIAL_TYPE_CONSTRUCT &&
        iTargetRace != RACIAL_TYPE_UNDEAD &&
        iTargetRace != RACIAL_TYPE_ELEMENTAL &&
        iTargetRace != RACIAL_TYPE_VERMIN &&
        !iBeholder)
     {
           int iHitEnemy = PRCDoRangedTouchAttack(oTarget);;

           if(iHitEnemy > 0)
           {
                int iDC = 10 + GetLevelByClass(CLASS_TYPE_PRC_EYE_OF_GRUUMSH, oCaster) + GetAbilityModifier(ABILITY_CONSTITUTION, oCaster);
                if(ReflexSave(oTarget, iDC, SAVING_THROW_TYPE_ACID, oCaster) == 0 && !GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS))
                {
                     effect eBlind = EffectBlindness();
                     ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oTarget);
                     DelayCommand(6.0,CheckBlindness(oTarget) );
                }
           }
     }
}
