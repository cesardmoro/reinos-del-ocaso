#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    int nBiowareSize = GetCreatureSize(oPC);
    int nPRCSize = PRCGetCreatureSize(oPC, TRUE); //only include things that change ability scores
    //change counters
    int nStr;
    int nDex;
    int nCon;
    int nACNatural;
    int nACDodge;
    int nAB;
    int nHide;
    //no size difference, abort
    if(nBiowareSize == nPRCSize)
        return;
    //increase
    else if(nPRCSize > nBiowareSize)
    {
        //smallest bioware size is tiny
        //these track if that change should be applied or not
        int nTinyToSmall;
        int nSmallToMedium;
        int nMediumToLarge;
        int nLargeToHuge;
        int nHugeToGargantuan;
        int nGargantuanToColossal;
        
        if(nPRCSize >= CREATURE_SIZE_SMALL          && nBiowareSize <= CREATURE_SIZE_TINY)
            nTinyToSmall = TRUE;    
        if(nPRCSize >= CREATURE_SIZE_MEDIUM         && nBiowareSize <= CREATURE_SIZE_SMALL)
            nSmallToMedium = TRUE;  
        if(nPRCSize >= CREATURE_SIZE_LARGE          && nBiowareSize <= CREATURE_SIZE_MEDIUM)
            nMediumToLarge = TRUE;   
        if(nPRCSize >= CREATURE_SIZE_HUGE           && nBiowareSize <= CREATURE_SIZE_LARGE)
            nLargeToHuge = TRUE;   
        if(nPRCSize >= CREATURE_SIZE_GARGANTUAN     && nBiowareSize <= CREATURE_SIZE_HUGE)
            nHugeToGargantuan = TRUE;   
        if(nPRCSize >= CREATURE_SIZE_COLOSSAL       && nBiowareSize <= CREATURE_SIZE_COLOSSAL)
            nGargantuanToColossal = TRUE; 
        
        //add in the bonuses
        //each size category is cumulative
        if(nTinyToSmall)
        {
            nStr        +=  4;
            nDex        += -2;
            nCon        +=  0;
            nACNatural  +=  0;
            nACDodge    += -1;
            nAB         += -1;
            nHide       += -4;
        }
        if(nSmallToMedium)
        {
            nStr        +=  2;
            nDex        += -2;
            nCon        +=  2;
            nACNatural  +=  0;
            nACDodge    += -1;
            nAB         += -1;
            nHide       += -4;
        }
        if(nMediumToLarge)
        {
            nStr        +=  8;
            nDex        += -2;
            nCon        +=  4;
            nACNatural  +=  2;
            nACDodge    += -1;
            nAB         += -1;
            nHide       += -4;
        }
        if(nLargeToHuge)
        {
            nStr        +=  8;
            nDex        += -2;
            nCon        +=  4;
            nACNatural  +=  3;
            nACDodge    += -1;
            nAB         += -1;
            nHide       += -4;
        }
        if(nHugeToGargantuan)
        {
            nStr        +=  8;
            nDex        +=  0;
            nCon        +=  4;
            nACNatural  +=  4;
            nACDodge    += -2;
            nAB         += -2;
            nHide       += -4;
        }
        if(nGargantuanToColossal)
        {
            nStr        +=  8;
            nDex        +=  0;
            nCon        +=  4;
            nACNatural  +=  5;
            nACDodge    += -4;
            nAB         += -4;
            nHide       += -4;
        }
    }
    //decrease
    else if(nPRCSize < nBiowareSize)
    {
        //largest bioware size is huge
        //these track if that change should be applied or not
        int nDiminuativeToFine;
        int nTinyToDiminuative;
        int nSmallToTiny;
        int nMediumToSmall;
        int nLargeToMedium;
        int nHugeToLarge;
        
        if(nPRCSize <= CREATURE_SIZE_FINE           && nBiowareSize >= CREATURE_SIZE_DIMINUTIVE)
            nDiminuativeToFine = TRUE;    
        if(nPRCSize >= CREATURE_SIZE_DIMINUTIVE    && nBiowareSize <= CREATURE_SIZE_TINY)
            nTinyToDiminuative = TRUE;  
        if(nPRCSize >= CREATURE_SIZE_TINY           && nBiowareSize <= CREATURE_SIZE_SMALL)
            nSmallToTiny = TRUE;   
        if(nPRCSize >= CREATURE_SIZE_SMALL          && nBiowareSize <= CREATURE_SIZE_MEDIUM)
            nMediumToSmall = TRUE;   
        if(nPRCSize >= CREATURE_SIZE_MEDIUM         && nBiowareSize <= CREATURE_SIZE_LARGE)
            nLargeToMedium = TRUE;   
        if(nPRCSize >= CREATURE_SIZE_LARGE          && nBiowareSize <= CREATURE_SIZE_HUGE)
            nHugeToLarge = TRUE; 
        
        //add in the bonuses
        //each size category is cumulative
        if(nDiminuativeToFine)
        {
            nStr        +=  0;
            nDex        +=  2;
            nCon        +=  0;
            nACNatural  +=  0;
            nACDodge    +=  4;
            nAB         +=  4;
            nHide       +=  4;
        }
        if(nTinyToDiminuative)
        {
            nStr        += -2;
            nDex        +=  2;
            nCon        +=  0;
            nACNatural  +=  0;
            nACDodge    +=  2;
            nAB         +=  2;
            nHide       +=  4;
        }
        if(nSmallToTiny)
        {
            nStr        += -4;
            nDex        +=  2;
            nCon        +=  0;
            nACNatural  +=  0;
            nACDodge    +=  1;
            nAB         +=  1;
            nHide       +=  4;
        }
        if(nMediumToSmall)
        {
            nStr        += -4;
            nDex        +=  2;
            nCon        += -2;
            nACNatural  +=  0;
            nACDodge    +=  1;
            nAB         +=  1;
            nHide       +=  4;
        }
        if(nLargeToMedium)
        {
            nStr        += -8;
            nDex        +=  2;
            nCon        += -4;
            nACNatural  += -2;
            nACDodge    +=  1;
            nAB         +=  1;
            nHide       +=  4;
        }
        if(nHugeToLarge)
        {
            nStr        += -8;
            nDex        +=  2;
            nCon        += -4;
            nACNatural  += -3;
            nACDodge    +=  1;
            nAB         +=  1;
            nHide       +=  4;
        }    
    }       
        
    //see if they are increase or decrease types;
    int nStrType;
    int nDexType;
    int nConType;
    int nACNaturalType;
    int nACDodgeType;
    int nHideType;
    
    
    if(nStr>=0)
        nStrType = ITEM_PROPERTY_ABILITY_BONUS;
    else        
    {
        nStrType = ITEM_PROPERTY_DECREASED_ABILITY_SCORE;
        nStr *= -1;//make it positive
    }        
    if(nDex>=0)
        nDexType = ITEM_PROPERTY_ABILITY_BONUS;
    else   
    {
        nDexType = ITEM_PROPERTY_DECREASED_ABILITY_SCORE;
        nDex *= -1;//make it positive
    }    
    if(nCon>=0)
        nConType = ITEM_PROPERTY_ABILITY_BONUS;
    else
    {
        nConType = ITEM_PROPERTY_DECREASED_ABILITY_SCORE; 
        nCon *= -1;//make it positive 
    }    
    if(nACNatural>=0)
        nACNaturalType = ITEM_PROPERTY_AC_BONUS;
    else
    {
        nACNaturalType = ITEM_PROPERTY_DECREASED_AC;  
        nACNatural *= -1;//make it positive
    }    
    if(nACDodge>=0)
        nACDodgeType = ITEM_PROPERTY_AC_BONUS;
    else
    {
        nACDodgeType = ITEM_PROPERTY_DECREASED_AC; 
        nACDodge *= -1;//make it positive 
    }    
    if(nHide>=0)
        nHideType = ITEM_PROPERTY_SKILL_BONUS;
    else
    {
        nHideType = ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER; 
        nHide *= -1;//make it positive 
    }    
    
    //now apply the bonuses
    object oSkin = GetPCSkin(oPC);
    object oLH = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    object oRH = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    SetCompositeBonus(oSkin, "SizeChangesStr", nStr, nStrType, ABILITY_STRENGTH);
    SetCompositeBonus(oSkin, "SizeChangesDex", nDex, nDexType, ABILITY_DEXTERITY);
    SetCompositeBonus(oSkin, "SizeChangesCon", nCon, nConType, ABILITY_CONSTITUTION);
    SetCompositeBonus(oSkin, "SizeChangesHide", nHide, nHideType, SKILL_HIDE);
    SetCompositeAttackBonus(oPC, "SizeChangesAB", nAB);
    //AC has a subtype if its a penalty, but not if its a bonus
    //yeah, that makes a lot of sense bioware(!)
    SetCompositeBonus(oSkin, "SizeChangesACN", nACNatural, nACNaturalType, IP_CONST_ACMODIFIERTYPE_NATURAL);
    SetCompositeBonus(oSkin, "SizeChangesACD", nACDodge, nACDodge, IP_CONST_ACMODIFIERTYPE_DODGE);  
}