//::///////////////////////////////////////////////
//:: Create Undead
//:: NW_S0_CrUndead.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell summons a Ghoul, Shadow, Ghast, Wight or
    Wraith
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
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    location targetLocation = PRCGetSpellTargetLocation();

    //Set the summoned undead to the appropriate template based on the caster level
    string resRefNoMuerto;
    if (nCasterLevel <= 11)
    {
        resRefNoMuerto = "NW_S_GHOUL";
    }
    else if ((nCasterLevel >= 12) && (nCasterLevel <= 13))
    {
        resRefNoMuerto = "NW_S_GHAST";
    }
    else if ((nCasterLevel >= 14) && (nCasterLevel <= 15))
    {
        resRefNoMuerto = "NW_S_WIGHT"; // change later
    }
    else if ((nCasterLevel >= 16))
    {
        resRefNoMuerto = "NW_S_SPECTRE";
    }

    //Apply VFX impact and summon effect
    object noMuerto = CreateObject(OBJECT_TYPE_CREATURE, resRefNoMuerto, targetLocation);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(noMuerto));
	ChangeToStandardFaction( noMuerto, STANDARD_FACTION_HOSTILE );

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

