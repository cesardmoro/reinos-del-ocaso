//::///////////////////////////////////////////////
//:: Frenzied Berserker - Supreme Power Attack
//:: NW_S1_frebzk
//:: Copyright (c) 2004 
//:: Special thanks to mr bumpkin for the GetWeaponDamageType function  :)
//:://////////////////////////////////////////////
/*
    Decreases attack by 10 and increases damage by 20
    Damage is based on weapon type (Slashing, peircing, etc.)
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "inc_addragebonus"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

#include "x2_inc_itemprop" // for checking if item is a weapon

void main()
{
     effect eDamage;
     effect eToHit;
     int bIsMeleeWeapon = FALSE;
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
     
     if(!GetWeaponRanged(oWeap) )
     {
          bIsMeleeWeapon = TRUE;
     }
     
     if(GetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_POWER_ATTACK) == FALSE && !GetActionMode(OBJECT_SELF, ACTION_MODE_POWER_ATTACK == FALSE))
     {
          if(!GetHasFeatEffect(FEAT_SUPREME_POWER_ATTACK) && bIsMeleeWeapon)
          {
                
              int iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK1,OBJECT_SELF)  ? SPELL_POWER_ATTACK1 : 0;
                  iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK2,OBJECT_SELF)  ? SPELL_POWER_ATTACK2 : iSpell;
                  iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK3,OBJECT_SELF)  ? SPELL_POWER_ATTACK3 : iSpell;
                  iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK4,OBJECT_SELF)  ? SPELL_POWER_ATTACK4 : iSpell;
                  iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK5,OBJECT_SELF)  ? SPELL_POWER_ATTACK5 : iSpell;
                  iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK6,OBJECT_SELF)  ? SPELL_POWER_ATTACK6 : iSpell;
                  iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK7,OBJECT_SELF)  ? SPELL_POWER_ATTACK7 : iSpell;
                  iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK8,OBJECT_SELF)  ? SPELL_POWER_ATTACK8 : iSpell;
                  iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK9,OBJECT_SELF)  ? SPELL_POWER_ATTACK9 : iSpell;
                  iSpell =  GetHasSpellEffect(SPELL_POWER_ATTACK10,OBJECT_SELF) ? SPELL_POWER_ATTACK10: iSpell;
   
               if(!iSpell) 
               {      
                 int nDamageBonusType = GetDamageTypeOfWeapon(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
                 eDamage = EffectDamageIncrease(DAMAGE_BONUS_20, nDamageBonusType);               
                 eToHit = EffectAttackDecrease(10);

                 effect eLink = ExtraordinaryEffect(EffectLinkEffects(eDamage, eToHit));
                 ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);
               
                 string nMes = "*Supreme Power Attack Mode Activated*";
                 FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
               }
          }
          else
          {          
               RemoveSpellEffects(GetSpellId(), OBJECT_SELF, OBJECT_SELF);

               string nMes = "*Supreme Power Attack Mode Deactivated*";
               FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
          }          
     }
}