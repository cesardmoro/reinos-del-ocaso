/*
  Echo of the Edge
  prc_iaijutsu_edg
  works for 1 attack only
*/

#include "NW_I0_GENERIC"
#include "prc_feat_const"
#include "inc_combat"
void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int iMod = 0;

    int nDamage = d6(1);
    int iSkill = GetSkillRank(SKILL_IAIJUTSU_FOCUS,oPC)+ d20();

    if(iSkill == 10 || iSkill < 15){ nDamage = d6(1); }  // 10-14 +1d6
    if(iSkill == 15 || iSkill < 20){ nDamage = d6(2); }  // 15-19 +2d6
    if(iSkill == 20 || iSkill < 25){ nDamage = d6(3); }  // 20-24 +3d6
    if(iSkill == 25 || iSkill < 30){ nDamage = d6(4); }  // 25-29 +4d6
    if(iSkill == 30 || iSkill < 35){ nDamage = d6(5); }  // 30-34 +5d6
    if(iSkill == 35 || iSkill < 40){ nDamage = d6(6); }  // 35-39 +6d6
    if(iSkill == 40 || iSkill < 45){ nDamage = d6(7); }  // 40-44 +7d6
    if(iSkill == 45 || iSkill < 50){ nDamage = d6(8); }  // 45-49 +8d6
    if(iSkill >= 50)               { nDamage = d6(9); }  // 50+   +9d6

    if(GetHasFeat(FEAT_EPIC_IAIJUTSU_FOCUS))
    {
    if(iSkill == 55 || iSkill < 60){ nDamage = d6(10); }
    if(iSkill == 60 || iSkill < 65){ nDamage = d6(11); }
    if(iSkill == 65 || iSkill < 70){ nDamage = d6(12); }
    if(iSkill == 70 || iSkill < 75){ nDamage = d6(13); }
    if(iSkill == 75 || iSkill < 80){ nDamage = d6(14); }
    if(iSkill == 80 || iSkill < 85){ nDamage = d6(15); }
    if(iSkill == 85 || iSkill < 90){ nDamage = d6(16); }
    if(iSkill == 90 || iSkill < 95){ nDamage = d6(17); }
    if(iSkill == 95 || iSkill < 100){ nDamage = d6(18); }
    if(iSkill == 100 || iSkill < 105){ nDamage = d6(19); }
    if(iSkill == 105 || iSkill < 110){ nDamage = d6(20); }
    if(iSkill == 110 || iSkill < 115){ nDamage = d6(21); }
    if(iSkill == 115 || iSkill < 120){ nDamage = d6(22); }
    if(iSkill == 120 || iSkill < 125){ nDamage = d6(23); }
    if(iSkill == 125 || iSkill < 130){ nDamage = d6(24); }
    if(iSkill == 130 || iSkill < 135){ nDamage = d6(25); }
    if(iSkill == 135 || iSkill < 140){ nDamage = d6(26); }
    if(iSkill == 140 || iSkill < 145){ nDamage = d6(27); }
    if(iSkill == 145 || iSkill < 150){ nDamage = d6(28); }
    if(iSkill == 150 || iSkill < 155){ nDamage = d6(29); }
    if(iSkill == 155 || iSkill < 160){ nDamage = d6(30); }
    if(iSkill == 160 || iSkill < 165){ nDamage = d6(31); }
    if(iSkill == 165 || iSkill < 170){ nDamage = d6(32); }
    if(iSkill == 170 || iSkill < 175){ nDamage = d6(33); }
    if(iSkill == 175 || iSkill < 180){ nDamage = d6(34); }
    if(iSkill >= 180)                { nDamage = d6(35); }
    }

    int iReturn = DoMeleeAttack(oPC,oWeap,oTarget,iMod,TRUE, 0.0);

    if(iReturn = 2)
    {
       int iDamage = GetMeleeWeaponDamage(oPC,oWeap,TRUE,0);
       iDamage = (iDamage + nDamage) / 2;
       effect eDam = EffectDamage(iDamage,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_NORMAL);
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
       FloatingTextStringOnCreature("Critical Echoes of the Edge",OBJECT_SELF);
       ActionAttack(oTarget);
    }
    else
    {
       int iDamage = GetMeleeWeaponDamage(oPC,oWeap,FALSE,0);
       iDamage = (iDamage + nDamage) / 2;
       effect eDam = EffectDamage(iDamage,DAMAGE_TYPE_SLASHING,DAMAGE_POWER_NORMAL);
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT,eDam,oTarget);
       FloatingTextStringOnCreature("Echoes of the Edge",OBJECT_SELF);
       ActionAttack(oTarget);
    }
}
