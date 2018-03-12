/////////////////////////////////////////////////////////////////////
//
// Living Undeath - Target becomes partially undead, gains immunity
// to critical hits and -4 CHA.
//
/////////////////////////////////////////////////////////////////////

#include "spinc_common"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    SPSetSchool(SPELL_SCHOOL_NECROMANCY);

    // Get the target and raise the spell cast event.
    object oTarget = GetSpellTargetObject();
    if (!GetIsObjectValid(oTarget)) oTarget = OBJECT_SELF;
    SPRaiseSpellCastAt(oTarget, FALSE);

       int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    // Determine the spell's duration, taking metamagic feats into account.
    float fDuration = SPGetMetaMagicDuration(MinutesToSeconds(nCasterLvl));
    if( !GetIsPC(OBJECT_SELF) || GetIsDMPossessed(OBJECT_SELF) || GetGold(OBJECT_SELF) >= 150)
    {
        TakeGoldFromCreature(150, OBJECT_SELF, TRUE);
        // Apply the buff and vfx.
        object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF);
        effect eEffect = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
        eEffect = EffectLinkEffects(eEffect, EffectAbilityDecrease(ABILITY_CHARISMA, 4));
        eEffect = EffectLinkEffects(eEffect, EffectMovementSpeedDecrease(60));
        eEffect = EffectLinkEffects(eEffect, EffectVisualEffect(VFX_DUR_PARALYZED));
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertySpecialWalk(), oSkin, fDuration);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, fDuration,TRUE,-1,nCasterLvl);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_L), oTarget);
    } else
        SendMessageToPC(OBJECT_SELF, "No tienes el oro suficiente para usar este conjuro.");
    SPSetSchool();
}
