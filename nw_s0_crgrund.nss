//::///////////////////////////////////////////////
//:: Create Greater Undead
//:: NW_S0_CrGrUnd.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an undead type pegged to the character's
    level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    location targetLocation = PRCGetSpellTargetLocation();
    int nDuration = nCasterLevel;
    nDuration = 24;
    effect efectoVisual = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

    //Make metamagic extend check
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    //Determine undead to summon based on level
    string resRefSummon;
    if (nCasterLevel <= 15)
    {
        resRefSummon = "NW_S_VAMPIRE";
    }
    else if ((nCasterLevel >= 16) && (nCasterLevel <= 17))
    {
        resRefSummon = "NW_S_DOOMKGHT";
    }
    else if ((nCasterLevel >= 18) && (nCasterLevel <= 19))
    {
        resRefSummon = "NW_S_LICH";
    }
    else
    {
        resRefSummon = "NW_S_MUMCLERIC";
    }

    //Apply summon effect and VFX impact.
    object noMuerto = CreateObject(OBJECT_TYPE_CREATURE, resRefSummon, targetLocation);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, efectoVisual, GetLocation(noMuerto));
	ChangeToStandardFaction( noMuerto, STANDARD_FACTION_HOSTILE );


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

