//::///////////////////////////////////////////////
//:: Passive Feats
//:: prc_ft_passive.nss
//:://////////////////////////////////////////////
/*
    Because Saving throw bonuses as itemprops gets
    screwed by divine grace
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: 20 November 2005
//:: Modified By: Flaming_Sword
//:: Modified On: 20 November 2005
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    if(GetHasFeat(FEAT_FORCE_PERSONALITY, oPC))
    {
        RemoveEffectsFromSpell(oPC, SPELL_FORCE_PERSONALITY);
        ActionCastSpellOnSelf(SPELL_FORCE_PERSONALITY);
    }
    if(GetHasFeat(FEAT_INSIGHTFUL_REFLEXES, oPC))
    {
        RemoveEffectsFromSpell(oPC, SPELL_INSIGHTFUL_REFLEXES);
        ActionCastSpellOnSelf(SPELL_INSIGHTFUL_REFLEXES);
    }
    if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC))
    {
        RemoveEffectsFromSpell(oPC, SPELL_INTUITIVE_ATK);
        ActionCastSpellOnSelf(SPELL_INTUITIVE_ATK);
    }    
}