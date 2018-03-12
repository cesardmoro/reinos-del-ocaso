/*:://////////////////////////////////////////////
//:: Spell Name Shocking Grasp
//:: Spell FileName PHS_S_ShockGrasp
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Creature or object touched will deal 1d8 + 1 damage (Max +20) (electrical)
    and gets a +3 attack bonus if the opponent is wearing metal armor. Level 1.
    No save!
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    We make a melee attack (with a +3 modifier for 2 seconds if they have metal
    armor).
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

// Returns the armor type of oItem (IE clothing, Full plate, ETC).
int GetArmorType(object oItem);

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_SHOCKING_GRASP)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    // Touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

    // Calculate max damage bonus
    int nBonusDamage = PHS_LimitInteger(nCasterLevel, 20); // Max of +20 damage

    //Declare effects
    effect eDamage, eAttack;
    // Special VFX
    effect eVis = EffectVisualEffect(PHS_VFX_IMP_SHOCKING_GRASP);

    // Here, we make a check for armor - we add 3 to attack for a second if it is metal.
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);
    // 4 is chain, anything bigger is of course more.
    if(GetArmorType(oArmor) >= 4)
    {
        // 2 seconds of it - max time needed really :-)
        eAttack = EffectAttackIncrease(3);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, OBJECT_SELF, 2.0);
    }

    // Needs to hit.
    if(nTouch)
    {
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Spell resistance and globe check - no turning for touch attacks, however.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Damage - can critical
                nDamage = PHS_MaximizeOrEmpower(6, 1, nMetaMagic, nBonusDamage, nTouch);

                // Do damage and VFX
                PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_ELECTRICAL);
            }
        }
    }
}

//::///////////////////////////////////////////////
//:: GetArmorType
//:://////////////////////////////////////////////
/*
    This function is a simple trick to identify
    the base armor stage of an item.  Return
    values correspond to the armor stages found on
    Table 9: Armor Stats of the NWN manual.  A
    value of -1 is returned if the item is invalid
    or could not be identified as a valid armor.
*/
//:://////////////////////////////////////////////
//:: Created By: Eyrdan (darkpope@hotmail.com)
//:: Created On: Dec 22, 2002
//:://////////////////////////////////////////////

int GetArmorType(object oItem)
{
    // Make sure the item is valid and is an armor.
    if (!GetIsObjectValid(oItem))
        return -1;
    if (GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
        return -1;

    // Get the identified flag for safe keeping.
    int bIdentified = GetIdentified(oItem);
    SetIdentified(oItem,FALSE);

    int iType = -1;
    switch (GetGoldPieceValue(oItem))
    {
        case    1: iType = 0; break; // None
        case    5: iType = 1; break; // Padded
        case   10: iType = 2; break; // Leather
        case   15: iType = 3; break; // Studded Leather / Hide
        case  100: iType = 4; break; // Chain Shirt / Scale Mail
        case  150: iType = 5; break; // Chainmail / Breastplate
        case  200: iType = 6; break; // Splint Mail / Banded Mail
        case  600: iType = 7; break; // Half-Plate
        case 1500: iType = 8; break; // Full Plate
    }
    // Restore the identified flag, and return armor type.
    SetIdentified(oItem,bIdentified);
    return iType;
}
