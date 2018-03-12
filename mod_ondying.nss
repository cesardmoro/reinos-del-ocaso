//::///////////////////////////////////////////////
//:: Dying Script
//:: NW_O0_DEATH.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script handles the default behavior
    that occurs when a player is dying.
    DEFAULT CAMPAIGN: player dies automatically
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: November 6, 2001
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_spell_const"
#include "prc_class_const"
#include "NW_I0_GENERIC"
#include "domains_inc"

void main()
{
/*    AssignCommand(GetLastPlayerDying(), ClearAllActions());
    AssignCommand(GetLastPlayerDying(),SpeakString( "I Dying"));
    PopUpGUIPanel(GetLastPlayerDying(),GUI_PANEL_PLAYER_DEATH);
*/
// * April 14 2002: Hiding the death part from player

    object oDying =GetLastPlayerDying();

    RetributionDomain_onDying(oDying);

    if (GetHasFeat(FEAT_SHADOWDISCOPOR, oDying) &&
     ( GetIsAreaAboveGround(GetArea(oDying))==AREA_UNDERGROUND || GetIsNight()|| GetHasEffect(EFFECT_TYPE_DARKNESS, oDying)) )
    {
     int iDice=d20();

     if (iDice+GetReflexSavingThrow(oDying)>=5+GetLocalInt(oDying,"DmgDealt"))
     {
       string sFeedback = "*Reflex Save vs Death : *success* :(" + IntToString(iDice) + " + " + IntToString(GetReflexSavingThrow(oDying)) + " = " + IntToString(iDice+GetReflexSavingThrow(oDying)) + " vs. DD:"+ IntToString(5+GetLocalInt(oDying,"DmgDealt"))+")";
       FloatingTextStringOnCreature(sFeedback, oDying);

        location locJump = GetRandomLocation(GetArea(oDying), oDying, 30.0f);

        ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oDying);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1 - (GetCurrentHitPoints(oDying))), oDying);
       SignalEvent(oDying,EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
       AssignCommand(oDying,ClearAllActions());
       AssignCommand(oDying,ActionJumpToLocation(locJump));
       return;

     }
        string sFeedback = "*Reflex Save vs Death : *failed* :(" + IntToString(iDice) + " + " + IntToString(GetReflexSavingThrow(oDying)) + " = " + IntToString(iDice+GetReflexSavingThrow(oDying)) + " vs. DD:"+ IntToString(5+GetLocalInt(oDying,"DmgDealt"))+")";
        FloatingTextStringOnCreature(sFeedback, oDying);

   }

    // Code added by Oni5115 for Remain Concious
    if(GetHasFeat(FEAT_REMAIN_CONSCIOUS, oDying) && GetCurrentHitPoints(oDying) > -10)
    {
         int pc_Damage = (GetCurrentHitPoints(oDying) * -1) + 1;
         int prev_Damage = GetLocalInt(oDying, "PC_Damage");

         // Store damage taken in a local variable
         pc_Damage = pc_Damage + prev_Damage;
         SetLocalInt(oDying, "PC_Damage", pc_Damage);

         if(pc_Damage < 10)
         {
              ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(), oDying);
         }
         else
         {
              effect eDeath = EffectDeath(FALSE, FALSE);
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, GetLastPlayerDying());
              SetLocalInt(oDying, "PC_Damage", 0);
         }

         string sFeedback = GetName(oDying) + " : Current HP = " + IntToString(pc_Damage * -1);
         SendMessageToPC(oDying, sFeedback);
    }
    else
    {
         // Standard death effect from BioWare
       if(GetCurrentHitPoints(GetLastPlayerDying()) == 0)
         {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(1), GetLastPlayerDying());
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), GetLastPlayerDying(), 1.0);
         }

         if(GetCurrentHitPoints(GetLastPlayerDying()) > -10 && GetCurrentHitPoints(GetLastPlayerDying()) < 0)
         {
         if(GetHasEffect(GetEffectType(EffectHitPointChangeWhenDying(-1.0)) ,GetLastPlayerDying()) == FALSE)
         {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHitPointChangeWhenDying(-1.0), GetLastPlayerDying());
         }
         }



    }

    ExecuteScript("prc_ondying", oDying);

}
