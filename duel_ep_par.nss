
//:////////////////////////////////////
//:  Duelist - Elaborate Parry - Parry mode
//:
//:  Gains bonus to parry skill equal to duelist level
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
          int iDuelistLevel = GetLevelByClass(CLASS_TYPE_DUELIST, oPC);

          effect eParry = SupernaturalEffect(EffectSkillIncrease(SKILL_PARRY, iDuelistLevel));

          ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParry, oPC);

          FloatingTextStringOnCreature("*Elaborate Parry: Parry Mode On*", oPC, FALSE);
     }
     else
     {
          // Removes effects from any version of the spell
          RemoveSpellEffects(SPELL_ELABORATE_PARRY_P, oPC, oPC);
          RemoveSpellEffects(SPELL_ELABORATE_PARRY_FD, oPC, oPC);

          FloatingTextStringOnCreature("*Elaborate Parry Off*", oPC, FALSE);
     }
}
