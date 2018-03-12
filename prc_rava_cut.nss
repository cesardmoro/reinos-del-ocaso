//::///////////////////////////////////////////////
//:: Cruelest Cut
//:: rava_cruelestcut
//::
//:://////////////////////////////////////////////
/*
    Target takes Constitution damage of 1d4 for 5 rds
    plus 1 round for every ravager level
*/
//:://////////////////////////////////////////////
//:: Created By: aser
//:: Created On: Feb/21/04
//:: Updated by Oni5115 9/23/2004 to use new combat engine
//:://////////////////////////////////////////////

#include "prc_inc_combat"

void main()
{
     //Declare major variables
     object oPC = OBJECT_SELF;
     object oTarget = GetSpellTargetObject();
     object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
     int iDur = 5 + GetLevelByClass(CLASS_TYPE_RAVAGER, oPC);
     int bIsRangedAttack = GetWeaponRanged(oWeap);
     
     effect eCon  = EffectAbilityDecrease(ABILITY_CONSTITUTION, d4(1) );
            eCon = SupernaturalEffect(eCon);
     
     // script now uses combat system to hit and apply effect if appropriate
     string sSuccess = "*Cruelist Cut Hit*";
     string sMiss = "*Cruelist Cut Miss";

     if (bIsRangedAttack)
     {
          SendMessageToPC(oPC,"You must use a melee weapon with this ability!");
          IncrementRemainingFeatUses(oPC, 2348);
          return;
     }
        
     // If they are not within 5 ft, they can't do a melee attack.
     if(!bIsRangedAttack && GetIsInMeleeRange(oTarget, oPC))
     {
          SendMessageToPC(oPC,"You are not close enough to your target to attack!");
          IncrementRemainingFeatUses(oPC, 2348);
          return;
     }
     
     PerformAttackRound(oTarget, oPC, eCon, RoundsToSeconds(iDur), 0, 0, 0, FALSE, sSuccess, sMiss);
}
