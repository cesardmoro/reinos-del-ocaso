//::///////////////////////////////////////////////
//:: Invisibility Purge
//:: NW_S0_InvPurge.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All invisible creatures become invisible in the
    area of effect even if they leave the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

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


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(35);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    effect eDur1 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eDur1, eDur2);

    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
