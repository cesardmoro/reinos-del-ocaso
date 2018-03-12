//::///////////////////////////////////////////////
//:: Summon Monster II
//:: NW_S0_Summon2
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a dire boar to fight for the character
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12 , 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "x2_inc_spellhook"
void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    /*
      Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

        if (!X2PreSpellCastCode())
        {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
            return;
        }

    // End of Spell Cast Hook

    if (!CanCastSpell(2)) return;

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN)/2;
    if (GetLocalInt(OBJECT_SELF, "Apal_DeathKnell") == TRUE)
    {
        nDuration = nDuration + 1;
    }    
    effect eSummon = EffectSummonCreature("NW_S_BOARDIRE");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER))
    {
        eSummon = EffectSummonCreature("NW_S_WOLFDIRE");
    }
    //Make metamagic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Apply the VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), TurnsToSeconds(nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

