//::///////////////////////////////////////////////
//:: Elemental Swarm
//:: NW_S0_EleSwarm.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell creates a conduit from the caster
    to the elemental planes.  The first elemental
    summoned is a 24 HD Air elemental.  Whenever an
    elemental dies it is replaced by the next
    elemental in the chain Air, Earth, Water, Fire
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 30, 2001

//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR",SPELL_SCHOOL_CONJURATION);
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
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = 24;
    effect eSummon;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    //Check for metamagic duration
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }
    //Set the summoning effect
    eSummon = EffectSwarm(FALSE, "NW_SW_AIRGREAT", "NW_SW_WATERGREAT","NW_SW_EARTHGREAT","NW_SW_FIREGREAT");
    //Apply the summon effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

