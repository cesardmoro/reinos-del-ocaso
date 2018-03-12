//::///////////////////////////////////////////////
//:: Animate Dead
//:: NW_S0_AnimDead.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons a powerful skeleton or zombie depending
    on caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"
#include "x2_inc_spellhook"
#include "animatedead_inc"

void main()
{
    object oCaster = OBJECT_SELF;
    DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nDuration = 24;
    location targetLocation = GetSpellTargetLocation();

    //CONJURO CUSTOM
    lanzarAnimarMuertos(oTarget, targetLocation, nCasterLevel, nMetaMagic, oCaster);
    return;

    //effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSummon;
    //Metamagic extension if needed
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }
    //Summon the appropriate creature based on the summoner level
    if (nCasterLevel <= 5)
    {
        //Tyrant Fog Zombie
        eSummon = EffectSummonCreature("NW_S_ZOMBTYRANT",VFX_FNF_SUMMON_UNDEAD);
    }
    else if ((nCasterLevel >= 6) && (nCasterLevel <= 9))
    {
        //Skeleton Warrior
        eSummon = EffectSummonCreature("NW_S_SKELWARR",VFX_FNF_SUMMON_UNDEAD);
    }
    else
    {
        //Skeleton Chieftain
        eSummon = EffectSummonCreature("NW_S_SKELCHIEF",VFX_FNF_SUMMON_UNDEAD);
    }
    //Apply the summon visual and summon the two undead.
    //ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, targetLocation, HoursToSeconds(nDuration));

    DeleteLocalInt(oCaster, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name

}


