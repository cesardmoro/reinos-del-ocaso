//::///////////////////////////////////////////////
//:: Cloudkill
//:: NW_S0_CloudKill.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d10 Poison damage
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"
#include "PHS_INC_SPELLS"
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


    //Declare major variables
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGKILL);
    location lTarget = GetSpellTargetLocation();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF) / 2;
    effect eImpact = EffectVisualEffect(258);
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_INSANITY);
    effect eLink = EffectLinkEffects(eImpact, eVis);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eLink, lTarget);
    if(nDuration < 1)
    {
        nDuration = 1;
    }
    int nMetaMagic = GetMetaMagicFeat();
        //Metamagic checks for entend
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        {
            nDuration = nDuration *2;   //Duration is +100%
        }
    //Apply the AOE object to the specified location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
