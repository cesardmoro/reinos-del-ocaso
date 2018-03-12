/*

Unstoppable
prc_lgdr_unstop
+20 attack bonus for 1 Round
Unless I can make it 1 Attack

*/
/*
void main()
{
    //Old Spell Code
    //Declare major variables
    object oTarget;
    oTarget = OBJECT_SELF;

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
    effect eAttack = EffectAttackIncrease(20);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = eAttack;
    eLink = EffectLinkEffects(eLink, eDur);

    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 9.0);

}
*/
#include "NW_I0_GENERIC"
#include "inc_combat"
void main()
{
  object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int iMod = 20;

    int iEnhancement = GetWeaponEnhancement(oWeap);
    int iDamageType = GetWeaponDamageType(oWeap);

    int iReturn = DoMeleeAttack(oPC,oWeap,oTarget,iMod,TRUE, 0.0);

    if(iReturn = 2)
    {
       int iDamage = GetMeleeWeaponDamage(oPC,oWeap,TRUE,0);
       effect eDam = EffectDamage(iDamage,iDamageType,iEnhancement);
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
       FloatingTextStringOnCreature("Critical Unstoppable Attack",OBJECT_SELF);
       ActionAttack(oTarget);

    }

    else
    {
       int iDamage = GetMeleeWeaponDamage(oPC,oWeap,FALSE,0);
       effect eDam = EffectDamage(iDamage,iDamageType,iEnhancement);
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
       FloatingTextStringOnCreature("Unstoppable Attack",OBJECT_SELF);
       ActionAttack(oTarget);

    }
}
