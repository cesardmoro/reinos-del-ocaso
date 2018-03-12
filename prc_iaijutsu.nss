 /*
  Iaijutsu Attack Script
  prc_iaijutsu
*/

#include "NW_I0_GENERIC"
#include "x0_i0_position"
#include "prc_feat_const"
#include "inc_combat"
void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oAttacker = GetLastAttacker(OBJECT_SELF);
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    object oWeap = GetFirstItemInInventory(oPC);
    int nDamage = d6(1);
    int iChaMod = GetAbilityModifier(ABILITY_CHARISMA,oPC);
    int iMod = 0;
    int iSkill = GetSkillRank(SKILL_IAIJUTSU_FOCUS,oPC)+ d20();
    string OneKat;
    int iDie = 0;

    SetLocalInt(oPC,OneKat,0);

    if(iSkill >= 10 && iSkill < 15){ nDamage = d6(1); iDie = 1; }  // 10-14 +1d6
    if(iSkill >= 15 && iSkill < 20){ nDamage = d6(2); iDie = 2; }  // 15-19 +2d6
    if(iSkill >= 20 && iSkill < 25){ nDamage = d6(3); iDie = 3; }  // 20-24 +3d6
    if(iSkill >= 25 && iSkill < 30){ nDamage = d6(4); iDie = 4; }  // 25-29 +4d6
    if(iSkill >= 30 && iSkill < 35){ nDamage = d6(5); iDie = 5; }  // 30-34 +5d6
    if(iSkill >= 35 && iSkill < 40){ nDamage = d6(6); iDie = 6; }  // 35-39 +6d6
    if(iSkill >= 40 && iSkill < 45){ nDamage = d6(7); iDie = 7; }  // 40-44 +7d6
    if(iSkill >= 45 && iSkill < 50){ nDamage = d6(8); iDie = 8; }  // 45-49 +8d6
    if(iSkill >= 50)               { nDamage = d6(9); iDie = 9; }  // 50+   +9d6

    if(GetHasFeat(FEAT_EPIC_IAIJUTSU_FOCUS))
    {
    if(iSkill >= 55 && iSkill < 60){ nDamage = d6(10); iDie = 10; }
    if(iSkill >= 60 && iSkill < 65){ nDamage = d6(11); iDie = 11; }
    if(iSkill >= 65 && iSkill < 70){ nDamage = d6(12); iDie = 12; }
    if(iSkill >= 70 && iSkill < 75){ nDamage = d6(13); iDie = 13; }
    if(iSkill >= 75 && iSkill < 80){ nDamage = d6(14); iDie = 14; }
    if(iSkill >= 80 && iSkill < 85){ nDamage = d6(15); iDie = 15; }
    if(iSkill >= 85 && iSkill < 90){ nDamage = d6(16); iDie = 16; }
    if(iSkill >= 90 && iSkill < 95){ nDamage = d6(17); iDie = 17; }
    if(iSkill >= 95 && iSkill < 100){ nDamage = d6(18); iDie = 18; }
    if(iSkill >= 100 && iSkill < 105){ nDamage = d6(19); iDie = 19; }
    if(iSkill >= 105 && iSkill < 110){ nDamage = d6(20); iDie = 20; }
    if(iSkill >= 110 && iSkill < 115){ nDamage = d6(21); iDie = 21; }
    if(iSkill >= 115 && iSkill < 120){ nDamage = d6(22); iDie = 22; }
    if(iSkill >= 120 && iSkill < 125){ nDamage = d6(23); iDie = 23; }
    if(iSkill >= 125 && iSkill < 130){ nDamage = d6(24); iDie = 24; }
    if(iSkill >= 130 && iSkill < 135){ nDamage = d6(25); iDie = 25; }
    if(iSkill >= 135 && iSkill < 140){ nDamage = d6(26); iDie = 26; }
    if(iSkill >= 140 && iSkill < 145){ nDamage = d6(27); iDie = 27; }
    if(iSkill >= 145 && iSkill < 150){ nDamage = d6(28); iDie = 28; }
    if(iSkill >= 150 && iSkill < 155){ nDamage = d6(29); iDie = 29; }
    if(iSkill >= 155 && iSkill < 160){ nDamage = d6(30); iDie = 30; }
    if(iSkill >= 160 && iSkill < 165){ nDamage = d6(31); iDie = 31; }
    if(iSkill >= 165 && iSkill < 170){ nDamage = d6(32); iDie = 32; }
    if(iSkill >= 170 && iSkill < 175){ nDamage = d6(33); iDie = 33; }
    if(iSkill >= 175 && iSkill < 180){ nDamage = d6(34); iDie = 34; }
    if(iSkill >= 180)                { nDamage = d6(35); iDie = 35; }
    }

    if(GetHasFeat(FEAT_STRIKE_VOID))
       {
       nDamage = nDamage + iChaMod*iDie;
       }

     if(oTarget != oPC)
     {
        if(!GetIsObjectValid(oItem2) && !GetIsObjectValid(oItem1))
         {
          while(GetIsObjectValid(oWeap) && GetLocalInt(oPC,OneKat) == 0)
           {

            if(GetBaseItemType(oWeap) == BASE_ITEM_KATANA)
            {
            int iAttack = DoMeleeAttack(oPC,oWeap,oTarget,iMod,TRUE,0.0);
            SetLocalInt(oPC,OneKat,1);

            if(iAttack == 2)
             {
              int iDamage = GetMeleeWeaponDamage(oPC,oWeap,TRUE,0);
              iDamage = iDamage + nDamage;
              effect eDam = EffectDamage(iDamage,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_NORMAL);
              ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
              FloatingTextStringOnCreature("Critical Iaijutsu Attack",OBJECT_SELF);
              ActionEquipItem(oWeap,INVENTORY_SLOT_RIGHTHAND);
              ActionAttack(oTarget);
             }
            if(iAttack == 1)
             {
              int iDamage = GetMeleeWeaponDamage(oPC,oWeap,FALSE,0);
              iDamage = iDamage + nDamage;
              effect eDam = EffectDamage(iDamage,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_NORMAL);
              ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
              FloatingTextStringOnCreature("Iaijutsu Attack",OBJECT_SELF);
              ActionEquipItem(oWeap,INVENTORY_SLOT_RIGHTHAND);
              ActionAttack(oTarget);
             }
            if(iAttack == 0)
             {
              FloatingTextStringOnCreature("Iaijutsu Failed",OBJECT_SELF);
              ActionEquipItem(oWeap,INVENTORY_SLOT_RIGHTHAND);
              ActionAttack(oTarget);
             }
            }
            oWeap = GetNextItemInInventory(oPC);
           }
         }
         else
         {
         FloatingTextStringOnCreature("Must have Katana unequiped, in inventory.",OBJECT_SELF);
         }
     }

     else if(GetIsObjectValid(oItem2))
     {
     ActionUnequipItem(oItem2);
     }

}