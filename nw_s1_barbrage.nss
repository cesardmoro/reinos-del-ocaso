//::///////////////////////////////////////////////
//:: Barbarian Rage
//:: NW_S1_BarbRage
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Str and Con of the Barbarian increases,
    Will Save are +2, AC -2.
    Greater Rage starts at level 15.
    
    Updated: 2004-01-18 mr_bumpkin: Added bonuses for exceeding +12 stat cap
    Updated: 2004-2-24 by Oni5115: Added Intimidating Rage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "inc_addragebonus"
#include "prc_class_const"
void main()
{
    if(!GetHasFeatEffect(FEAT_BARBARIAN_RAGE) && !GetHasSpellEffect(GetSpellId()))
    {
        //Declare major variables
        int nLevel = GetLevelByClass(CLASS_TYPE_BARBARIAN) + GetLevelByClass(CLASS_TYPE_RUNESCARRED) + GetLevelByClass(CLASS_TYPE_BATTLERAGER) + GetLevelByClass(CLASS_TYPE_EYE_OF_GRUUMSH);
        int iStr, iCon, iAC;
        int nSave;
        
        iAC = 2;

        //Lock: Added compatibility for PRC Mighty Rage ability
        if ((nLevel >= 15) && (GetHasFeat(FEAT_PRC_EPIC_MIGHT_RAGE, OBJECT_SELF)))
        {
            iStr = 8;
            iCon = 8;
            nSave = 4;
        }
	else if(nLevel >= 15)
	{
            iStr = 6;
            iCon = 6;
            nSave = 3;
	}
        else
        {
            iStr = 4;
            iCon = 4;
            nSave = 2;
        }

        // Eye of Gruumsh ability. Additional  +4 Str and -2 AC.
        if(GetHasFeat(FEAT_SWING_BLINDLY, OBJECT_SELF) )
        {
           iStr += 4;
           iAC += 2;
        }

        // play a random voice chat instead of just VOICE_CHAT_BATTLECRY1
        int iVoiceConst = 0;
        int iVoice = d3(1);
        switch(iVoice)
        {
             case 1: iVoice = VOICE_CHAT_BATTLECRY1;
                     break;
             case 2: iVoice = VOICE_CHAT_BATTLECRY2;
                     break;
             case 3: iVoice = VOICE_CHAT_BATTLECRY3;
                     break;
        }
        PlayVoiceChat(iVoice);
        
        //Determine the duration by getting the con modifier after being modified
        int nCon = 3 + GetAbilityModifier(ABILITY_CONSTITUTION) + iCon;
        effect eStr = EffectAbilityIncrease(ABILITY_CONSTITUTION, iCon);
        effect eCon = EffectAbilityIncrease(ABILITY_STRENGTH, iStr);
        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave);
        effect eAC = EffectACDecrease(iAC, AC_DODGE_BONUS);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        effect eLink = EffectLinkEffects(eCon, eStr);
        eLink = EffectLinkEffects(eLink, eSave);
        eLink = EffectLinkEffects(eLink, eAC);
        eLink = EffectLinkEffects(eLink, eDur);
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_BARBARIAN_RAGE, FALSE));
        //Make effect extraordinary
        eLink = ExtraordinaryEffect(eLink);
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); //Change to the Rage VFX

        if (nCon > 0)
        {
            // 2004-01-18 mr_bumpkin: determine the ability scores before adding bonuses, so the values
            // can be read in by the GiveExtraRageBonuses() function below.
            int StrBeforeBonuses = GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH);
            int ConBeforeBonuses = GetAbilityScore(OBJECT_SELF,ABILITY_CONSTITUTION);
            int ExtRage = GetHasFeat(FEAT_EXTENDED_RAGE, OBJECT_SELF) ? 5:0;
            
            nCon+= ExtRage;
            
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nCon));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF) ;

            // 2003-07-08, Georg: Rage Epic Feat Handling
            CheckAndApplyEpicRageFeats(nCon);
 
            // 2004-01-18 mr_bumpkin: Adds special bonuses to those barbarians who are restricted by the
            // +12 attribute bonus cap, to make up for them. :)
 
            // The delay is because you have to delay the command if you want the function to be able
            // to determine what the ability scores become after adding the bonuses to them.
            DelayCommand(0.1, GiveExtraRageBonuses(nCon, StrBeforeBonuses, ConBeforeBonuses, iStr, iCon, nSave, DAMAGE_TYPE_FIRE, OBJECT_SELF));


            // 2004-2-24 Oni5115: Intimidating Rage
            if(GetHasFeat(FEAT_INTIMIDATING_RAGE, OBJECT_SELF) ) // 4312
            {
		 // Finds nearest visible enemy within 30 ft.
                 object oTarget = GetNearestSeenOrHeardEnemy();   
                 float distance = GetDistanceBetween(OBJECT_SELF, oTarget);
                 
                 if(distance < FeetToMeters(30.0) )
                 {
                       // Will save DC 10 + 1/2 Char level + Cha mod
                       int charLevel = GetHitDice(OBJECT_SELF);
                       int saveDC = 10 + (charLevel/2) + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
		       int nResult = WillSave(oTarget, saveDC, SAVING_THROW_TYPE_NONE);
		       
		       if(nResult == 0)
		       {
                            // Same effect as Doom Spell
                            effect eLink = CreateDoomEffectsLink();
                            effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(nCon));
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		       }
		 }
	    }   
        }
    }
}
