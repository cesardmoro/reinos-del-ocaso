#include "prc_feat_const"
#include "prc_spell_const"
#include "nw_i0_spells"

void main()
{
    object oCreature = GetSpellTargetObject();
    object oRighthand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature);
    object oLefthand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature);   
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature);
    int iExtraAttacks = 0;
    int iBrawlerAttacks = GetLocalInt(oCreature, "BrawlerAttacks");
        
    if (!GetHasSpellEffect(SPELL_BRAWLER_EXTRA_ATT, oCreature))
    {
        if (GetHasFeat(FEAT_BRAWLER_EXTRAATT_1, oCreature))
        {
            if (!GetIsObjectValid(oRighthand))
            {
                if (!GetIsObjectValid(oLefthand) || GetBaseItemType(oLefthand) == BASE_ITEM_TORCH)
                {
                    if (!GetLevelByClass(CLASS_TYPE_MONK, oCreature))
                    {
                        if (GetHasFeat(FEAT_BRAWLER_EXTRAATT_3, oCreature))
                        {
                            iExtraAttacks = 3;
			    FloatingTextStringOnCreature("*Extra unarmed attacks enabled: Three extra attacks per round*", oCreature, FALSE);
			}
                        else if (GetHasFeat(FEAT_BRAWLER_EXTRAATT_2, oCreature))
                        {
                            iExtraAttacks = 2;
                            FloatingTextStringOnCreature("*Extra unarmed attacks enabled: Two extra attacks per round*", oCreature, FALSE);
                        }
                        else
                        {
                            iExtraAttacks = 1;
                            FloatingTextStringOnCreature("*Extra unarmed attack enabled: One extra attack per round*", oCreature, FALSE);
                        }
                    }
                    else FloatingTextStringOnCreature("*Extra unarmed attack not enabled: Cannot stack with monk*", oCreature, FALSE);
                }
                else FloatingTextStringOnCreature("*Extra unarmed attack not enabled: Shield equipped*", oCreature, FALSE);
            }
            else FloatingTextStringOnCreature("*Extra unarmed attack not enabled: Weapon equipped*", oCreature, FALSE);
        }

        if (!iExtraAttacks) return;
        
	SetLocalInt(oCreature, "BrawlerAttacks", iExtraAttacks);
        
        effect eExtraAttacks = SupernaturalEffect(EffectModifyAttacks(iExtraAttacks));

        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eExtraAttacks, oCreature);
    }
}
