#include "x0_i0_spells"
#include "prc_inc_combat"
#include "x2_inc_itemprop"

void main()
{
    object oPC = GetSpellTargetObject();
    object oTarget = GetEnteringObject();
    object PCMarshal = GetAreaOfEffectCreator();
    object WeapMar = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget); 
     
    
    int MarshRange = IPGetIsRangedWeapon(WeapMar);
    int MarshCha = GetAbilityModifier(ABILITY_CHARISMA, PCMarshal);
    int MarshLev = GetLevelByClass(CLASS_TYPE_MARSHAL, PCMarshal);
    int MarshBon;
    int MarshSpeed;
    

    
    if (MarshLev>1)
       {
       MarshBon = 1;
       MarshSpeed = 15;
       }
    if (MarshLev>6)
       {
       MarshBon = 2;
       MarshSpeed = 30;
       }
    if (MarshLev>13)
       {
       MarshBon = 3;
       MarshSpeed = 45;
       }
    if (MarshLev>19)
       {
       MarshBon = 4;
       MarshSpeed = 60;
       }
    if (MarshLev>24)
       {
       MarshBon = 5;
       MarshSpeed = 75;
       }
    if (MarshLev>29)
       {
       MarshBon = 6;
       MarshSpeed = 80;
       }
     if (MarshLev>34)
       {
       MarshBon = 7;
       MarshSpeed = 99;
       }
    if (MarshLev>39)
       {
       MarshBon = 8;
       MarshSpeed = 99;
       }
       
    if (GetHasFeat(FEAT_TYPE_ELEMENTAL, oPC) >= 10 && GetHasFeat(FEAT_BONDED_AIR,oPC))
        MarshSpeed += 30;
    if (MarshSpeed > 99) MarshSpeed = 99;
    
    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))   
    {
            //Motivate Ardor
            if(GetHasSpellEffect(3511, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageIncrease(MarshBon, IP_CONST_DAMAGETYPE_SLASHING), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
              
            //Motivate Care
            if(GetHasSpellEffect(3512, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectACIncrease(MarshBon, AC_DODGE_BONUS), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
            //Resilient Troops
            if(GetHasSpellEffect(3513, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSavingThrowIncrease(SAVING_THROW_ALL, MarshBon, SAVING_THROW_TYPE_ALL), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
            //Motivate Urgency
            if(GetHasSpellEffect(3514, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT,ExtraordinaryEffect(EffectMovementSpeedIncrease(MarshSpeed)),oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
            //Hardy Soldiers
            if(GetHasSpellEffect(3515, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, MarshBon), oTarget);
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_PIERCING, MarshBon), oTarget);
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamageResistance(DAMAGE_TYPE_SLASHING, MarshBon), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
            //Motivate Attack
            if(GetHasSpellEffect(3516, PCMarshal)) 
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 if (MarshRange<1)
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackIncrease(MarshBon), oTarget);
                 }
                 }
              }
            //Steady Hand
            if(GetHasSpellEffect(3517, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                  SetLocalInt(PCMarshal,"MarshalMajor",1);
                  if (IPGetIsRangedWeapon(WeapMar))
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAttackIncrease(MarshBon), oTarget);
                 }
                 }
              }
            //Major Charisma Boost
            if(GetHasSpellEffect(3519, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_CHARISMA, MarshBon), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
            //Major Constitution Boost
            if(GetHasSpellEffect(3520, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_CONSTITUTION, MarshBon), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
            //Major Dexterity Boost
            if(GetHasSpellEffect(3521, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_DEXTERITY, MarshBon), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
            //Major Intelligence Boost
            if(GetHasSpellEffect(3522, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_INTELLIGENCE, MarshBon), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
            //Major Strength Boost
            if(GetHasSpellEffect(3523, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_STRENGTH, MarshBon), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }
            //Major Wisdom Boost
            if(GetHasSpellEffect(3524, PCMarshal))
              {
              if (GetLocalInt(PCMarshal,"MarshalMajor")>0) 
                 {
                 return;
                 }
              else
                 {
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAbilityIncrease(ABILITY_WISDOM, MarshBon), oTarget);
                 SetLocalInt(PCMarshal,"MarshalMajor",1);
                 }
              }

    }
}
