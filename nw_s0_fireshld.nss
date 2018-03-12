//::///////////////////////////////////////////////
//:: Elemental Shield
//:: NW_S0_FireShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 50% cold and fire immunity.  Also anyone
    who strikes the caster with melee attacks takes
    1d6 + 1 per caster level in damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Created On: Aug 28, 2003, GZ: Fixed stacking issue
#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "RdO_Spell_const"

void main()
{

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
    effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nDamage = (nDuration >= 15) ? 15 : nDuration;
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = OBJECT_SELF;
    effect eFireShield = EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
    effect eColdShield = EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCold = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
    effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ELEMENTAL_SHIELD, FALSE));

    RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD_COLD, OBJECT_SELF, oTarget);
    RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD_FIRE, OBJECT_SELF, oTarget);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    effect eShield = eDur;
    int spellId = GetSpellId();
    if (spellId == SPELL_ELEMENTAL_SHIELD_FIRE)
    {
        eShield = EffectLinkEffects(eShield, eCold);
        eShield = EffectLinkEffects(eShield, eFireShield);
        eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD));
    }
    else if (spellId == SPELL_ELEMENTAL_SHIELD_COLD)
    {
        eShield = EffectLinkEffects(eShield, eFire);
        eShield = EffectLinkEffects(eShield, eColdShield);
        eShield = EffectLinkEffects(eShield, EffectVisualEffect(VFX_DUR_CHILL_SHIELD));
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShield, oTarget, RoundsToSeconds(nDuration));
}

