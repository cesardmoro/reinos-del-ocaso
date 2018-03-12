/*

This is a function to evaluate and apply SetBaseAttackBonus
after taking all the PRC sources into account and choosing one appropriately

Run from prc_inc_function EvalPRCFeats()

*/

#include "prc_alterations"
#include "prc_inc_natweap"

void main()
{
    object oPC = OBJECT_SELF;
    int nAttackCount = -1;
    int nOverflowAttackCount;
    
    //count the number of class-derived attacks
    int nBAB = GetMainHandAttacks(oPC);
    
        
    //permanent type ones
    //conditions in which this applies
    if(GetIsUsingPrimaryNaturalWeapons(oPC))
    {
        //creature weapon test
        //get the value
        int nNaturalPrimary = GetLocalInt(oPC, NATURAL_WEAPON_ATTACK_COUNT);
        nAttackCount = nNaturalPrimary;
    }
    else
    {    
        //monk correction
        if(GetLevelByClass(CLASS_TYPE_MONK, oPC))
            nAttackCount = nBAB;
        
        //temporary type ones
        if(GetHasSpellEffect(SPELL_DIVINE_POWER, oPC)
            && nBAB < 4)
        {
            int nDPAttackCount = GetLocalInt(oPC, "AttackCount_DivinePower");
            if(nDPAttackCount > nAttackCount)
                nAttackCount = nDPAttackCount;
        }
        if(GetHasSpellEffect(SPELL_TENSERS_TRANSFORMATION, oPC)
            && nBAB < 4)
        {
            int nTTAttackCount = GetLocalInt(oPC, "AttackCount_TensersTrans");
            if(nTTAttackCount > nAttackCount)
                nAttackCount = nTTAttackCount;
        }       
    }
    
    //default
    if(nAttackCount == -1)
    {
        RestoreBaseAttackBonus(oPC);
        DeleteLocalInt(oPC, "OverrideBaseAttackCount");
        DeleteLocalInt(oPC, "OverflowBaseAttackCount");
    }    
    else
    {
        
        if(nAttackCount > 5)
        {       
            nOverflowAttackCount += nAttackCount-5;
            nAttackCount = 5;
        }    
        if(nOverflowAttackCount)    
        {    
            SetLocalInt(oPC, "OverflowBaseAttackCount", nOverflowAttackCount);
        }
        SetBaseAttackBonus(nAttackCount, oPC);
        SetLocalInt(oPC, "OverrideBaseAttackCount", nAttackCount);
    }
    
    //offhand calculations
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
    {
        int nOffhand = 1;
        if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING, oPC))
            nOffhand = 2;
        else if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC) )
            nOffhand = 3;
        else if(GetHasFeat(FEAT_SUPREME_TWO_WEAPON_FIGHTING, oPC) )
            nOffhand = 4;
        else if(GetHasFeat(FEAT_PERFECT_TWO_WEAPON_FIGHTING, oPC) )
            nOffhand = nAttackCount+nOverflowAttackCount;
            
        if(nOffhand <= 2)
            DeleteLocalInt(oPC, "OffhandOverflowAttackCount");
        else 
            SetLocalInt(oPC, "OffhandOverflowAttackCount", nOffhand-2);
    }    
}