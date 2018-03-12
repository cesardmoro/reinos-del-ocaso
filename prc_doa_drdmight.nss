//::///////////////////////////////////////////////
//:: Disciple of Asmodeus Damage/Attack/Saves
//:: prc_doa_drdmight.nss
//:://////////////////////////////////////////////
//:: Applies Disciple of Asmodeus Bonuses by using
//:: ActionCastSpellOnSelf via prc_discasmodeus
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    effect eDam = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_DIVINE);
    effect eAtk = EffectAttackIncrease(2);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    effect eLink = EffectLinkEffects(eDam, eAtk);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = ExtraordinaryEffect(eLink);

    RemoveEffectsFromSpell(oPC, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}
