
//:////////////////////////////////////
//:  Duelist - Elaborate Parry - Defensive Fighting Mode mode
//:
//:  Gains 12 AC and trades away 4 attack.
//:
//:////////////////////////////////////
//:  By: Oni5115
//:////////////////////////////////////
#include "prc_alterations"
#include "prc_class_const"
#include "prc_spell_const"

void main()
{
     object oPC = OBJECT_SELF;
     object oSkin = GetPCSkin(oPC);
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

     if( !GetHasSpellEffect(SPELL_ELABORATE_PARRY_P) && !GetHasSpellEffect(SPELL_ELABORATE_PARRY_FD) )
     {
          int iDuelistLevel = GetLevelByClass(CLASS_TYPE_DUELIST, oPC) + 2;
          if (iDuelistLevel > 12) iDuelistLevel = 12;

          effect eAC = EffectACIncrease(iDuelistLevel, AC_SHIELD_ENCHANTMENT_BONUS);
          effect eAttackPenalty = EffectAttackDecrease(4, ATTACK_BONUS_MISC);
          effect eLink = SupernaturalEffect(EffectLinkEffects(eAC, eAttackPenalty));

          ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);

          FloatingTextStringOnCreature("*Elaborate Parry: Defensive Fighting Mode On*", oPC, FALSE);
     }
     else
     {
          // Removes effects from any version of the spell
          RemoveSpellEffects(SPELL_ELABORATE_PARRY_P, oPC, oPC);
          RemoveSpellEffects(SPELL_ELABORATE_PARRY_FD, oPC, oPC);

          FloatingTextStringOnCreature("*Elaborate Parry Off*", oPC, FALSE);
     }
}
