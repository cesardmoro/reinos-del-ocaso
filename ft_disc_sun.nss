//::///////////////////////////////////////////////
//:: Turn Undead
//:: NW_S2_TurnDead
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Checks domain powers and class to determine
    the proper turning abilities of the casting
    character.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 2, 2001
//:: Updated On: Jul 15, 2003 - Georg Zoeller
//:://////////////////////////////////////////////
//:: MODIFIED MARCH 5 2003 for Blackguards
//:: MODIFIED JULY 24 2003 for Planar Turning to include turn resistance hd
//:: Modified November 29, 2003 for Evil Cleric Rebuke/Command by Wes Baran
//:: Modified December 29, 2003 for 1.61 patch

// Checks to see if an evil cleric has control 'slots' to command
// the specified undead
// if TRUE, the cleric has enough levels of control to control the undead
// if FALSE, the cleric will rebuke the undead instead

#include "prc_alterations"

void TurnUndead(int nTurnLevel, int nTurnHD, int nVermin, int nElemental, int nConstructs, int nOutsider, int nClassLevel, int nPlanar) {
    //Gets all creatures in a 20m radius around the caster and turns them or not.  If the creatures
    //HD are 1/2 or less of the nClassLevel then the creature is destroyed.
    int nCnt = 1;
    int nHD, nRacial, nHDCount, bValid, nDamage;
    nHDCount = 0;
    effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDamage;
    effect eTurned = EffectTurned();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eVisTurn, eTurned);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eDeath = SupernaturalEffect(EffectDeath(TRUE));

    effect eImpactVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(OBJECT_SELF));   
     
    //Get nearest enemy within 20m (60ft)
    //Why are you using GetNearest instead of GetFirstObjectInShape
    // Because ability description says "gets closest first" :P
    object oTarget = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC , OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget) && nHDCount < nTurnHD && GetDistanceToObject(oTarget) <= 20.0)
    {
        if(!GetIsFriend(oTarget))
        {
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
            else //(full turn resistance)
            {
                  nHD = GetHitDice(oTarget) + GetTurnResistanceHD(oTarget);
            }

            if(nHD <= nTurnLevel && nHD <= (nTurnHD - nHDCount))
            {
                //Check the various domain turning types
                if(nRacial == RACIAL_TYPE_UNDEAD)
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_VERMIN && nVermin > 0)
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_ELEMENTAL && nElemental > 0)
                {
                    bValid = TRUE;
                }
                else if (nRacial == RACIAL_TYPE_CONSTRUCT && nConstructs > 0)
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                    nDamage = d3(nTurnLevel);
                    eDamage = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                    nHDCount += nHD;
                }
                else if (nRacial == RACIAL_TYPE_OUTSIDER && nOutsider > 0)
                {
                    bValid = TRUE;
                }

                //Apply results of the turn
                if( bValid == TRUE)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    //if(IntToFloat(nClassLevel)/2.0 >= IntToFloat(nHD))
                    //{

                   
                        //Fire cast spell at event for the specified target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                        //Destroy the target
                        DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                   
                    nHDCount = nHDCount + nHD;
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
  
   int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
   
   if (!GetHasFeat(FEAT_TURN_UNDEAD,OBJECT_SELF))  return;
   if ( nAlign != ALIGNMENT_GOOD) return;
   
   DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);

   if (!GetHasFeat(FEAT_TURN_UNDEAD,OBJECT_SELF))
   {
     IncrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);
     SpeakStringByStrRef(40550);
     return;
   }

   DecrementRemainingFeatUses(OBJECT_SELF,FEAT_TURN_UNDEAD);
    int nClericLevel = GetLevelByClass(CLASS_TYPE_CLERIC);
    int nPaladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN);
    int nBlackguardlevel = GetLevelByClass(CLASS_TYPE_BLACKGUARD);
    int nHospLevel = GetLevelByClass(CLASS_TYPE_HOSPITALER);
    int nSolLevel = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT);
    int nTNLevel = GetLevelByClass(CLASS_TYPE_TRUENECRO);
    int nTotalLevel =  GetHitDice(OBJECT_SELF);

    int nTurnLevel = nClericLevel;
    int nClassLevel = nClericLevel;

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
    }
    if((nHospLevel - 2) > 0)
    {
        nClassLevel += (nHospLevel -2);
        nTurnLevel  += (nHospLevel - 2);
    }
    if ( nAlign == ALIGNMENT_GOOD) 
    {
      nClassLevel += nSolLevel;
      nTurnLevel  += nSolLevel;
    }
    //Flags for bonus turning types
    int nElemental = GetHasFeat(FEAT_AIR_DOMAIN_POWER) + GetHasFeat(FEAT_EARTH_DOMAIN_POWER) + GetHasFeat(FEAT_FIRE_DOMAIN_POWER) + GetHasFeat(FEAT_WATER_DOMAIN_POWER);
    int nVermin = GetHasFeat(FEAT_PLANT_DOMAIN_POWER) + GetHasFeat(FEAT_ANIMAL_COMPANION);
    int nConstructs = GetHasFeat(FEAT_DESTRUCTION_DOMAIN_POWER);
    int nOutsider = GetHasFeat(FEAT_GOOD_DOMAIN_POWER) + GetHasFeat(FEAT_EVIL_DOMAIN_POWER);
    int nPlanar = GetHasFeat(854);

    //Flag for improved turning ability
    int nSun = GetHasFeat(FEAT_SUN_DOMAIN_POWER);
    int nMaster = GetHasFeat(FEAT_MASTER_OF_ENERGY);

    //Make a turning check roll, modify if have the Sun Domain
    int nChrMod = GetAbilityModifier(ABILITY_CHARISMA);
    int nTurnCheck = d20() + nChrMod;              //The roll to apply to the max HD of undead that can be turned --> nTurnLevel
    int nTurnHD = d6(2) + nChrMod + nClassLevel;   //The number of HD of undead that can be turned.

    if (GetHasFeat(FEAT_HEART_PASSION))
    {
      nTurnCheck +=2;
      nTurnHD +=2;
    }

    if(nMaster == TRUE)
    {
        nTurnCheck += 4;
        nTurnHD += 4;
    }
    if(nSun == TRUE)
    {
        nTurnCheck += d4();
        nTurnHD += d6();
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

    TurnUndead(nTurnLevel, nTurnHD, nVermin, nElemental, nConstructs, nOutsider, nClassLevel, nPlanar);

}
