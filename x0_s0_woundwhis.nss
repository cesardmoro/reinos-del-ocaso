//::///////////////////////////////////////////////
//:: Wounding Whispers
//:: x0_s0_WoundWhis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Magical whispers cause 1d8 sonic damage to attackers who hit you.
    Made the damage slightly more than the book says because we cannot
    do the +1 per level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Modified for wounding whispers, July 30 2002, Brent
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"
#include "prc_spell_const"

#include "x2_inc_spellhook"
#include "x0_i0_spells"
void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl; 
    int nBonus = nDuration;
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = OBJECT_SELF;
    effect eShield = EffectDamageShield(d6(1) + nBonus, 0, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_SONIC));
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 441, FALSE));

    if (GetHasSpellEffect(GetSpellId()))
    {
        RemoveSpellEffects(GetSpellId(),OBJECT_SELF,OBJECT_SELF);
    }
    
    if(GetHasSpellEffect(SPELL_MINSTREL_SONG_WOUND_WHISP))
    {
        RemoveSpellEffects(SPELL_MINSTREL_SONG_WOUND_WHISP,OBJECT_SELF,OBJECT_SELF);
    }

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    
    if (GetHasSpellEffect(SPELL_MINSTREL_SONG_WOUND_WHISP, oTarget))
    {
        effect eCheck = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eCheck))
        {
            if (GetEffectSpellId(eCheck) == SPELL_MINSTREL_SONG_WOUND_WHISP)
                RemoveEffect(oTarget, eCheck);
            eCheck = GetNextEffect(oTarget);
        }
    }
    
    //Apply the VFX impact and effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}
