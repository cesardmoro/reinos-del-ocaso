#include "prc_spell_const"
#include "nw_i0_spells"
#include "inc_item_props"

void main()
{
    object oPC = GetSpellTargetObject();
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iDamageType = (!GetIsObjectValid(oWeap)) ? DAMAGE_TYPE_BLUDGEONING : GetItemDamageType(oWeap);
    
    RemoveEffectsFromSpell(oPC, GetSpellId());
    
    effect eDam = EffectDamageIncrease(DAMAGE_BONUS_2, iDamageType);
    effect eAtk = EffectAttackIncrease(2);
    effect eLink = EffectLinkEffects(eDam, eAtk);
    eLink = ExtraordinaryEffect(eLink);
    
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}
