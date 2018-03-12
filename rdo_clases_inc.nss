#include "RDO_Clases_Itf"
#include "RDO_Const_Feat"
#include "PRC_Feat_Const"
#include "LetoCommands_inc"
#include "inc_item_props"
#include "x2_inc_ItemProp"
#include "RDO_Const_IPrp"
#include "RDO_SpInc"
#include "x2_inc_itemprop"


void RdO_Classes_Ranger_adjustCombatStyles( object oPC );
void RdO_Classes_Ranger_adjustCombatStyles( object oPC )
{
    if (GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 1)
    {
        object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        if (GetBaseAC(oArmor) <= 4)
        {
            int combatStyle = GetCampaignInt(Classes_DATABASE, Classes_DB_RANGER_COMBAT_STYLE, oPC);
            if (combatStyle == Ranger_COMBAT_STYLE_TWO_WEAPON)
            {
                if (GetHasFeat(FEAT_RANGER_IMP_COMBAT_STYLE, oPC))
                    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_TWO_WEAPON_FIGHTING), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                if (GetHasFeat(FEAT_RANGER_MST_COMBAT_STYLE, oPC))
                    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_GREATER_TWO_WEAPON_FIGHTING), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            }
            else if (combatStyle == Ranger_COMBAT_STYLE_BOW)
            {
                // ---> el Dual Wield del ranger parece estar hard coded y en base a la clase, no a la dote, por lo que es necesario compensarlo para abajo
                object effectCreator = RDO_GetCreatorByTag(Ranger_CombatStyle_EFFECT_CREATOR);
                RDO_RemoveEffectsByCreator(oPC, effectCreator);
                if (IPGetIsMeleeWeapon(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)))
                {
                    if (!GetHasFeat(FEAT_AMBIDEXTERITY, oPC))
                        AssignCommand(effectCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(4, ATTACK_BONUS_OFFHAND)), oPC));
                    if (!GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oPC)) {
                        AssignCommand(effectCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(2, ATTACK_BONUS_OFFHAND)), oPC));
                        AssignCommand(effectCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(2, ATTACK_BONUS_ONHAND)), oPC));
                    }
                }
                // <---

                if (GetHasFeat(FEAT_RANGER_COMBAT_STYLE, oPC))
                    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_RAPID_SHOT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                if (GetHasFeat(FEAT_RANGER_IMP_COMBAT_STYLE, oPC))
                    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_MANYSHOT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                if (GetHasFeat(FEAT_RANGER_MST_COMBAT_STYLE, oPC))
                    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_PINPOINT_ACCURACY), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
                if (GetHasFeat(FEAT_RANGER_MST_COMBAT_STYLE, oPC))
                    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_PERFECT_SHOT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
            }
            else
                AssignCommand(oPC, ActionStartConversation(oPC, "combat_style", TRUE, FALSE));
        }
        else
        {
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_TWO_WEAPON_FIGHTING));
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_GREATER_TWO_WEAPON_FIGHTING));
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_RAPID_SHOT));
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_MANYSHOT));
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_PINPOINT_ACCURACY));
            RemoveItemProperty(oSkin, ItemPropertyBonusFeat(IP_CONST_FEAT_PERFECT_SHOT));
        }
    }
}

// Agrega las nuevas dotes a los paladines que no las tengan
// Debe ir en el evento onEnter
void Classes_Paladin_addNewFeats( object oPC );
void Classes_Paladin_addNewFeats( object oPC )
{
    int paladinLevel = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);

    if (paladinLevel >= 2 && !GetHasFeat(FEAT_PALADIN_DETECT_EVIL, oPC))
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_PALADIN_DETECT_EVIL, 2));

    if (paladinLevel >= 5 && !GetHasFeat(FEAT_PALADIN_SPECIAL_MOUNT, oPC))
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_PALADIN_SPECIAL_MOUNT, 5));
}

void Classes_Paladin_AuraOfCourage( object oPC );
void Classes_Paladin_AuraOfCourage( object oPC )
{
    if (GetLevelByClass(CLASS_TYPE_PALADIN, oPC) > 2)
    {
        AssignCommand(RDO_GetCreatorByTag("EffectCreator_AuraPaladin"), ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectAreaOfEffect(AOE_MOB_CIRCGOOD, "pal_couragea", "", "pal_courageb"), oPC));
    }
}

// Agrega las nuevas dotes a los bardos que no las tengan
// Debe ir en el evento onEnter
void Classes_Bard_addNewFeats( object oPC );
void Classes_Bard_addNewFeats( object oPC )
{
    int bardLevel = GetLevelByClass(CLASS_TYPE_BARD, oPC);

    if (bardLevel >= 12 && !GetHasFeat(BARD_SONG_OF_FREEDOM, oPC))
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(BARD_SONG_OF_FREEDOM, 12));
}

// Agrega las nuevas dotes a los monjes que no las tengan
// Debe ir en el evento onEnter
void Classes_Monk_addNewFeats( object oPC );
void Classes_Monk_addNewFeats( object oPC )
{
    int monkLevel = GetLevelByClass(CLASS_TYPE_MONK, oPC);

    if (monkLevel >= 12 && !GetHasFeat(FEAT_MONK_ABUNDANT_STEP, oPC))
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_MONK_ABUNDANT_STEP, 12));
}

// Agrega las nuevas dotes a los monjes que no las tengan
// Debe ir en el evento onEnter
void Classes_Ranger_addNewFeats( object oPC );
void Classes_Ranger_addNewFeats( object oPC )
{
    int rangerLevel = GetLevelByClass(CLASS_TYPE_RANGER, oPC);

    if (rangerLevel == 1 && GetHasFeat(FEAT_RANGER_DUAL_WIELD, oPC) && GetXP(oPC) > 3000)
        Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_RANGER_DUAL_WIELD));
    else if ( rangerLevel > 1 &&
              GetCampaignInt(Classes_DATABASE, Classes_DB_RANGER_COMBAT_STYLE, oPC) == Ranger_COMBAT_STYLE_TWO_WEAPON &&
              !GetHasFeat(FEAT_RANGER_DUAL_WIELD, oPC)
             )
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_RANGER_DUAL_WIELD));

    if (rangerLevel >= 2 && !GetHasFeat(FEAT_TRACK, oPC))
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_TRACK, 2));

    if (rangerLevel >= 3 && !GetHasFeat(FEAT_ENDURANCE, oPC))
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_ENDURANCE, 3));

    if (rangerLevel >= 4 && !GetHasFeat(FEAT_ANIMAL_COMPANION, oPC))
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_ANIMAL_COMPANION, 4));

    if (rangerLevel >= 7 && !GetHasFeat(FEAT_WOODLAND_STRIDE, oPC))
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_WOODLAND_STRIDE, 7));

    if (rangerLevel >= 1 && GetCampaignInt(Classes_DATABASE, "SKILLS_RANGER_RESETEADAS", oPC)==FALSE)
    {
        int extraSkills = 8 + 2 * (rangerLevel-1);
        Leto_addScriptToPCStack(oPC, Leto_AdjustSpareSkill(extraSkills, 1));
        SetCampaignInt(Classes_DATABASE, "SKILLS_RANGER_RESETEADAS", TRUE, oPC);
    }
}

// Clases propias del modulo o modificaciones hechas a ellas por la casa
void RdO_Classes_onEquip( object oPC, object oItem );
void RdO_Classes_onEquip( object oPC, object oItem )
{
    RdO_Classes_Ranger_adjustCombatStyles( oPC );
}

// Clases propias del modulo o modificaciones hechas a ellas por la casa
void RdO_Classes_onUnequip( object oPC, object oItem );
void RdO_Classes_onUnequip( object oPC, object oItem )
{
    RdO_Classes_Ranger_adjustCombatStyles( oPC );
}

// Clases propias del modulo o modificaciones hechas a ellas por la casa
void RdO_Classes_onEnter( object oPC );
void RdO_Classes_onEnter( object oPC )
{
    Classes_Paladin_addNewFeats( oPC );
    Classes_Monk_addNewFeats( oPC );
    Classes_Bard_addNewFeats( oPC );
    Classes_Ranger_addNewFeats( oPC );
}

void RdO_Classes_onLevelUp( object oPC );
void RdO_Classes_onLevelUp( object oPC )
{
    RdO_Classes_Ranger_adjustCombatStyles( oPC );
}
