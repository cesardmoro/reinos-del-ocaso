//::///////////////////////////////////////////////
//:: Turn Outsider
//:: NW_S2_TurnDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////


#include "prc_alterations"

// Checks to see if an evil cleric has control 'slots' to command
// the specified undead
// if TRUE, the cleric has enough levels of control to control the undead
// if FALSE, the cleric will rebuke the undead instead
int CanCommand(int nClassLevel, int nTargetHD) {
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    int nNew = nSlots + nTargetHD;
    //FloatingTextStringOnCreature("The variable is " + IntToString(nSlots), OBJECT_SELF);
    if(nClassLevel >= nNew) {
        return TRUE;
    }
    return FALSE;
}

void AddCommand(int nTargetHD) {
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    SetLocalInt(OBJECT_SELF, "wb_clr_comm_slots", nSlots + nTargetHD);
}

void SubCommand(int nTargetHD) {
    int nSlots = GetLocalInt(OBJECT_SELF, "wb_clr_comm_slots");
    SetLocalInt(OBJECT_SELF, "wb_clr_comm_slots", nSlots - nTargetHD);
}

void TurnUndead(int nTurnLevel, int nTurnHD, int nVermin, int nElemental, int nConstructs, int nOutsider, int nClassLevel, int nPlanar) {
    //Gets all creatures in a 20m radius around the caster and turns them or not.  If the creatures
    //HD are 1/2 or less of the nClassLevel then the creature is destroyed.
    int nCnt = 1;
    int nHD, nRacial, nHDCount, bValid, nDamage;
    nHDCount = 0;
    effect eVisEvil = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    effect eVisTurnEvil = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eTurnedEvil = EffectCutsceneParalyze();
    effect eDurEvil = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLinkEvil = EffectLinkEffects(eVisTurnEvil, eTurnedEvil);
    eLinkEvil = EffectLinkEffects(eLinkEvil, eDurEvil);

    effect eDeathEvil = SupernaturalEffect(EffectCutsceneDominated());
    effect eDomin = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDeathLink = EffectLinkEffects(eDeathEvil, eDomin);

    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDamage;
    effect eTurned = EffectTurned();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eVisTurn, eTurned);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eDeath = SupernaturalEffect(EffectDeath(TRUE));

    effect eImpactVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    effect eImpactVisEvil = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);

    //Get nearest enemy within 20m (60ft)
    //Why are you using GetNearest instead of GetFirstObjectInShape
    // Because ability description says "gets closest first" :P
    object oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC , OBJECT_SELF, nCnt);
    
    int nAlign = GetAlignmentGoodEvil(oTarget);
    
    if (nAlign == ALIGNMENT_EVIL)
       ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVisEvil, GetLocation(OBJECT_SELF));
    else
       ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF)); 
     
    while(GetIsObjectValid(oTarget) && nHDCount < nTurnHD && GetDistanceToObject(oTarget) <= 20.0)
    {
        if(!GetIsFriend(oTarget))
        {
            nAlign = GetAlignmentGoodEvil(oTarget);
            nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
            nRacial = MyPRCGetRacialType(oTarget);

            if (nRacial == RACIAL_TYPE_OUTSIDER )
            {
                if (nPlanar)
                {
                     //Planar turning decreases spell resistance against turning by 1/2
                     nHD = GetHitDice(oTarget) + (GetSpellResistance(oTarget) /2) + GetTurnResistanceHD(oTarget);
                }
                else
                {
                    nHD = GetHitDice(oTarget) + (GetSpellResistance(oTarget) + GetTurnResistanceHD(oTarget) );
                }
            }
            

            if(nHD <= nTurnLevel && nHD <= (nTurnHD - nHDCount))
            {
                //Check the various domain turning types
               
                if (nRacial == RACIAL_TYPE_OUTSIDER )
                {
                    bValid = TRUE;
                }

                //Apply results of the turn
                if( bValid == TRUE)
                {
                    
                    if (nAlign == ALIGNMENT_EVIL)
                    {
                    	
                       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisEvil, oTarget);
                       //if(IntToFloat(nClassLevel)/2.0 >= IntToFloat(nHD))
                       //{

                       if((nClassLevel/2) >= nHD && CanCommand(nClassLevel, nHD))
                       {
                          //Fire cast spell at event for the specified target
                          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                          //Destroy the target
                          DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeathLink, oTarget, RoundsToSeconds(nClassLevel + 5)));
                          //AssignCommand(oTarget, ClearAllActions());
                          //SetIsTemporaryFriend(oTarget, OBJECT_SELF, TRUE, RoundsToSeconds(nClassLevel + 5));
                          AddCommand(nHD);
                          DelayCommand(RoundsToSeconds(nClassLevel + 5), SubCommand(nHD));
                       }
                       else
                       {
                          //Turn the target
                          //Fire cast spell at event for the specified target
                          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                          //AssignCommand(oTarget, ActionMoveAwayFromObject(OBJECT_SELF, TRUE));
                          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkEvil, oTarget, RoundsToSeconds(nClassLevel + 5));
                       }
                       nHDCount = nHDCount + nHD;
                    	
                    	
                    }
                    else
                    {
                      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                      //if(IntToFloat(nClassLevel)/2.0 >= IntToFloat(nHD))
                      //{

                      if((nClassLevel/2) >= nHD)
                      {
                          //Fire cast spell at event for the specified target
                          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                          //Destroy the target
                          DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                      }
                      else
                      {
                          //Turn the target
                          //Fire cast spell at event for the specified target
                          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                          AssignCommand(oTarget, ActionMoveAwayFromObject(OBJECT_SELF, TRUE));
                          // Added by SoulTaker and Modified by Starlight
                          // 2004-5-16
                          // Check whether Exalted Turning exist
                          // if yes, all turned undead take 3d6 damage also
                          if (GetHasFeat(FEAT_EXALTED_TURNING) && nRacial == RACIAL_TYPE_UNDEAD)
                             ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d6(3), DAMAGE_TYPE_DIVINE), oTarget);

                          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nClassLevel + 5));
                      }
                      nHDCount = nHDCount + nHD;
                    }
                }
            }
            bValid = FALSE;
        }
        nCnt++;
        oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC, OBJECT_SELF, nCnt);
    }
}

void main()
{
    int nClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC);
    int nPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN);
    int nBlackguardlevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    int nHospLevel = GetLevelByClass(CLASS_TYPE_HOSPITALER);
    int nSolLevel = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT);
    int nTNLevel = GetLevelByClass(CLASS_TYPE_TRUENECRO);
    int nTotalLevel =  GetHitDice(OBJECT_SELF);
    int nAntiPal = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN)-3;

    int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
    int nTurnLevel ;
    int nClassLevel ;
    int LevelPal = FALSE;

    if (!(GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_EVIL && GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_CHAOTIC)  )
    {
      FloatingTextStringOnCreature("Turn Outsider Failed : you're not Chaotic Evil",OBJECT_SELF);
      return;	
    }
    //Flags for bonus turning types
    int nOutsider = GetHasFeat(FEAT_GOOD_DOMAIN_POWER)+GetHasFeat(FEAT_EVIL_DOMAIN_POWER);
    int nPlanar = GetHasFeat(854);
  
    if ( nPlanar || nOutsider)
    {
      nTurnLevel = nClericLevel;
      nClassLevel = nClericLevel;

      // GZ: Since paladin levels stack when turning, blackguard levels should stack as well
      // GZ: but not with the paladin levels (thus else if).
      if(nTNLevel > 0)    
      {
        nClassLevel += (nTNLevel);
        nTurnLevel  += (nTNLevel);
      }
      if((nBlackguardlevel - 2) > 0 && (nBlackguardlevel > nPaladinLevel))
      {
        nClassLevel += (nBlackguardlevel - 2);
        nTurnLevel  += (nBlackguardlevel - 2);
      }
      else if((nPaladinLevel - 2) > 0)
      {
        nClassLevel += (nPaladinLevel -2);
        nTurnLevel  += (nPaladinLevel - 2);
        LevelPal = TRUE;
      }
      if((nHospLevel - 2) > 0)
      {
        nClassLevel += (nHospLevel -2);
        nTurnLevel  += (nHospLevel - 2);
      }
    }

    if (!LevelPal && nPaladinLevel>9)
    {
       nClassLevel += (nPaladinLevel -2);
       nTurnLevel  += (nPaladinLevel - 2);  	
    }
    nClassLevel += (nAntiPal);
    nTurnLevel  += (nAntiPal);
        
    //Flag for improved turning ability
    int nMaster = GetHasFeat(FEAT_MASTER_OF_ENERGY);

    //Make a turning check roll
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    int nTurnCheck = d20() + nChrMod;              //The roll to apply to the max HD of undead that can be turned --> nTurnLevel
    int nTurnHD = d6(2) + nChrMod + nClassLevel;   //The number of HD of undead that can be turned.

    if(nMaster == TRUE)
    {
        nTurnCheck += 4;
        nTurnHD += 4;
    }

    //Determine the maximum HD of the undead that can be turned.
    if(nTurnCheck <= 0)
    {
        nTurnLevel -= 4;
    }
    else if(nTurnCheck >= 1 && nTurnCheck <= 3)
    {
        nTurnLevel -= 3;
    }
    else if(nTurnCheck >= 4 && nTurnCheck <= 6)
    {
        nTurnLevel -= 2;
    }
    else if(nTurnCheck >= 7 && nTurnCheck <= 9)
    {
        nTurnLevel -= 1;
    }
    else if(nTurnCheck >= 10 && nTurnCheck <= 12)
    {
        //Stays the same
    }
    else if(nTurnCheck >= 13 && nTurnCheck <= 15)
    {
        nTurnLevel += 1;
    }
    else if(nTurnCheck >= 16 && nTurnCheck <= 18)
    {
        nTurnLevel += 2;
    }
    else if(nTurnCheck >= 19 && nTurnCheck <= 21)
    {
        nTurnLevel += 3;
    }
    else if(nTurnCheck >= 22)
    {
        nTurnLevel += 4;
    }

    int nEmpower = GetHasFeat(FEAT_EMPOWER_TURNING);
    nTurnHD = nEmpower ? nTurnHD+nTurnHD/2 : nTurnHD;

    TurnUndead(nTurnLevel, nTurnHD, FALSE, FALSE, FALSE, TRUE, nClassLevel, nPlanar);
    
}
