//::///////////////////////////////////////////////
//:: Desecrate
//:: prc_tn_des_a
//:://////////////////////////////////////////////
/*
    You create an aura that boosts the undead
    around you.
*/

#include "prc_alterations"

void main()
{
    //SendMessageToPC(GetFirstPC(), "UNDEAD are: " + IntToString(RACIAL_TYPE_UNDEAD));
//    SendMessageToPC(GetFirstPC(), "Desecrate has been entered");
    object oTarget = GetEnteringObject();
    effect eDam = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_NEGATIVE);
    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
    int nHP = GetHitDice(oTarget);
    effect eHP = EffectTemporaryHitpoints(nHP);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eLink = EffectLinkEffects(eDam, eAttack);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eHP);

    //FloatingTextStringOnCreature(ObjectToString(oTarget), GetFirstPC());
    
     int racialType = MyPRCGetRacialType(oTarget);
//     SendMessageToPC(GetFirstPC(), "Racial Type: " + IntToString(racialType));
    
            if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
  //             FloatingTextStringOnCreature("Entering Creature Is Undead", GetFirstPC());
               ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
               ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            }
            else
              ApplyEffectToObject(DURATION_TYPE_PERMANENT,  EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE ), oTarget);  

}
