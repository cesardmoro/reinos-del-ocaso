//::///////////////////////////////////////////////
//:: Order of the Bow Initiate Damage/Attack
//:: prc_ootbi_gwfcs.nss
//:://////////////////////////////////////////////
//:: Applies Order of the Bow Initiate Bonuses by using
//:: ActionCastSpellOnSelf
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    effect eAtk = EffectAttackIncrease(1);
    effect eLink = ExtraordinaryEffect(eAtk);

    RemoveEffectsFromSpell(oPC, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}
