#include "NW_I0_SPELLS"
#include "inc_utility"

void main()
{

   object oTarget = GetSpellTargetObject();

   object oSkin = GetPCSkin(oTarget);

   DelayCommand(0.2, SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE));
   DelayCommand(0.21, UseStealthMode());
   DelayCommand(0.2, ActionUseSkill(SKILL_HIDE, OBJECT_SELF));
   DelayCommand(0.2, ActionUseSkill(SKILL_MOVE_SILENTLY, OBJECT_SELF));

   //AddItemProperty(DURATION_TYPE_TEMPORARY,PRCItemPropertyBonusFeat(31),oSkin,3.0f);
   IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(31), 3.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   SetActionMode(oTarget,ACTION_MODE_STEALTH,TRUE);

}