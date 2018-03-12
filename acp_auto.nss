#include "prc_alterations"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_ipfeat_const"

const int PHENOTYPE_KENSAI      = 5;
const int PHENOTYPE_ASSASSIN    = 6;
const int PHENOTYPE_BARBARIAN   = 7;
const int PHENOTYPE_FENCING     = 8;

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    if(!GetHasFeat(FEAT_ACP_FEAT, oPC)
        && GetPRCSwitch(PRC_ACP_MANUAL))
    {
        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_ACP_FEAT), 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        return;
    }
    else if(((GetPRCSwitch(PRC_ACP_AUTOMATIC) && GetIsPC(oPC))
            ||(GetPRCSwitch(PRC_ACP_NPC_AUTOMATIC) && !GetIsPC(oPC))
            ||(GetLocalInt(oPC, PRC_ACP_NPC_AUTOMATIC) && !GetIsPC(oPC)))
        && !GetLocalInt(oPC, sLock))
    {
        int nKensaiScore,
            nAssassinScore,
            nBarbarianScore,
            nFencingScore;

        nKensaiScore += GetLevelByClass(CLASS_TYPE_SAMURAI, oPC);
        nKensaiScore += GetLevelByClass(CLASS_TYPE_CW_SAMURAI, oPC);
        nKensaiScore += GetLevelByClass(CLASS_TYPE_MONK, oPC);
        nKensaiScore += GetLevelByClass(CLASS_TYPE_IAIJUTSU_MASTER, oPC);
        nKensaiScore += GetLevelByClass(CLASS_TYPE_SHOU, oPC);

        nAssassinScore += GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
        nAssassinScore += GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC);
        nAssassinScore += GetLevelByClass(CLASS_TYPE_NINJA_SPY, oPC);
        nAssassinScore += GetLevelByClass(CLASS_TYPE_NIGHTSHADE, oPC);
        nAssassinScore += GetLevelByClass(CLASS_TYPE_BFZ, oPC);
        nAssassinScore += GetLevelByClass(CLASS_TYPE_SHADOWLORD, oPC);

        nBarbarianScore += GetLevelByClass(CLASS_TYPE_BARBARIAN, oPC);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_PRC_EYE_OF_GRUUMSH, oPC);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_ORC_WARLORD, oPC);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_FRE_BERSERKER, oPC);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_BATTLERAGER, oPC);
        nBarbarianScore += GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC);
        if(GetAbilityScore(oPC, ABILITY_STRENGTH)>20)
            nBarbarianScore += (GetAbilityScore(oPC, ABILITY_STRENGTH)-10)/2;

        nFencingScore += GetLevelByClass(CLASS_TYPE_BARD, oPC);
        nFencingScore += GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC);
        nFencingScore += GetLevelByClass(CLASS_TYPE_BLADESINGER, oPC);
        nFencingScore += GetLevelByClass(CLASS_TYPE_TEMPEST, oPC);
        nFencingScore += GetLevelByClass(CLASS_TYPE_BARD, oPC);
        if(GetAbilityScore(oPC, ABILITY_DEXTERITY)>20)
            nFencingScore += (GetAbilityScore(oPC, ABILITY_DEXTERITY)-10)/2;

        object oOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        object oOnhand = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

        if(GetBaseItemType(oOffhand) == BASE_ITEM_TOWERSHIELD
            || GetBaseItemType(oOffhand) == BASE_ITEM_LARGESHIELD)
        {
            nFencingScore = 0;
            nAssassinScore = 0;
            nKensaiScore = 0;
        }

        if(GetBaseItemType(oOffhand) == BASE_ITEM_SMALLSHIELD
            || GetWeaponDamageType(oOnhand) != DAMAGE_TYPE_PIERCING
            || GetIsTwoHandedMeleeWeapon(oOnhand))
        {
            nFencingScore = 0;
        }

        if(GetAbilityScore(oPC, ABILITY_STRENGTH)<15)
            nBarbarianScore = 0;

        int nAutoPhenotype = PHENOTYPE_NORMAL;
        int nBestScore;

        if(nKensaiScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_KENSAI;
            nBestScore = nKensaiScore;
        }
        if(nAssassinScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_ASSASSIN;
            nBestScore = nAssassinScore;
        }
        if(nBarbarianScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_BARBARIAN;
            nBestScore = nBarbarianScore;
        }
        if(nFencingScore > nBestScore)
        {
            nAutoPhenotype = PHENOTYPE_FENCING;
            nBestScore = nFencingScore;
        }

        if(GetPhenoType(oPC) != nAutoPhenotype)
        {
            SetPhenoType(nAutoPhenotype, oPC);
            LockThisFeat(oPC);
        }
    }
}