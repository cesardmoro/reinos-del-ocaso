//:://////////////////////////////////////////////
//:: Spell gain calculation script
//:: prc_spellgain
//:://////////////////////////////////////////////
/** @file
    This script determines whether a given character
    has power slots left unfilled. If the character
    does have some, it launches the power gain
    conversation.


    @date Modified - 2005.09.23
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_class_const"
#include "inc_dynconv"
#include "inc_newspellbook"


int CheckMissingSpells(object oPC, int nClass, int nMinLevel, int nMaxLevel)
{
    int nLevel = GetSpellslotLevel(nClass, oPC);
    if(!nLevel)
        return FALSE;
    if(nClass == CLASS_TYPE_BARD || nClass == CLASS_TYPE_SORCERER)
    {
        if(GetLevelByClass(nClass, oPC) == nLevel) //no PrC
            return FALSE;
    }
    int i;
    for(i=nMinLevel; i<=nMaxLevel; i++)
    {
        int nMaxSpells = GetSpellKnownMaxCount(nLevel, i, nClass, oPC);
        if(nMaxSpells > 0)
        {
            int nCurrentSpells = GetSpellKnownCurrentCount(oPC, i, nClass);
            if(nCurrentSpells < nMaxSpells)
            {
                // Mark the class for which the PC is to gain powers and start the conversation
                SetLocalInt(oPC, "SpellGainClass", nClass);
                SetLocalInt(oPC, "SpellbookMinSpelllevel", nMinLevel);
                SetLocalInt(oPC, "SpellbookMaxSpelllevel", nMaxLevel);
                StartDynamicConversation("prc_s_spellgain", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC);

                return TRUE;
            }
        }
    }
    return FALSE;
}

void main()
{
    object oPC = OBJECT_SELF;
    if(GetLocalInt(oPC, "nPCShifted"))
        return;
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectType(eTest) == EFFECT_TYPE_POLYMORPH)
            return;
        eTest = GetNextEffect(oPC);
    }
    if(!GetPRCSwitch(PRC_BARD_DISALLOW_NEWSPELLBOOK)
        && CheckMissingSpells(oPC, CLASS_TYPE_BARD, 0, 6))
        return;
    if(!GetPRCSwitch(PRC_SORC_DISALLOW_NEWSPELLBOOK)
        && CheckMissingSpells(oPC, CLASS_TYPE_SORCERER, 0, 9))
        return;
    if(CheckMissingSpells(oPC, CLASS_TYPE_SUEL_ARCHANAMACH, 1, 5))
        return;  
    if(CheckMissingSpells(oPC, CLASS_TYPE_FAVOURED_SOUL, 0, 9))
        return;        
    //add new classes here   
}