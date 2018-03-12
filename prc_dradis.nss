//::///////////////////////////////////////////////
//:: Dragon Disciple Immunities
//:: prc_dradis.nss
//::///////////////////////////////////////////////
/*
    Applies a variety of immunities to the multiple dragon disciple types.
*/
//:://////////////////////////////////////////////
//:: Created By: Silver
//:: Created On: Apr 27, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_class_const"
#include "prc_feat_const"
#include "prc_spell_const"
#include "prc_ip_srcost"
#include "Phenos_inc"
#include "Horses_inc"
#include "prc_inc_switch"
#include "prc_inc_natweap"
#include "inc_dradis"

const int CEP_IN_USE = TRUE;

//Adds total elemental immunity for the majority of dragon types.
void ElImmune(object oPC ,object oSkin ,int bResisEle ,int iType)
{
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertyDamageImmunity(iType,bResisEle),0.0));
}

//Adds poison immunity for certain dragon types.
//also adds immunity to level drain for shadow dragons.
void PoisImmu(object oPC ,object oSkin ,int bResisEle ,int pImmune)
{
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertyImmunityMisc(pImmune),0.0));
}

//Adds disease immunity for certain dragon types.
void DisImmu(object oPC ,object oSkin ,int bResisEle ,int dImmune)
{
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertyImmunityMisc(dImmune),0.0));
}

//Adds specific spell immunities for certain dragon types.
void SpellImmu(object oPC ,object oSkin ,int bResisEle ,int iSpell)
{
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertySpellImmunitySpecific(iSpell),0.0));
}

//Adds more spell immunities for certain dragon types.
void SpellImmu2(object oPC ,object oSkin ,int bResisEle ,int iSpel2)
{
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertySpellImmunitySpecific(iSpel2),0.0));
}

//Adds resistance 10 to cold and fire damage.
void SmallResist(object oPC ,object oSkin ,int bResisEle ,int sResis)
{
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_FIRE,sResis),0.0));
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,sResis),0.0));
}

//Adds immunity 50% to sonic and fire damage.
void LargeResist(object oPC ,object oSkin ,int bResisEle ,int lResis)
{
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_FIRE,lResis),0.0));
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_SONIC,lResis),0.0));
}

//Adds Spell Resistance of 20+Level to all Dragon Disciples at level 18.
void SpellResis(object oPC ,object oSkin ,int nLevel)
{
    int nSR = 20+nLevel;
    nSR = GetSRByValue(nSR);
    DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertyBonusSpellResistance(nSR),0.0));
}

//Adds True Seeing to all Dragon Disciples at level 20.
void SeeTrue(object oPC ,object oSkin ,int nLevel)
{
/*    if(GetPRCSwitch(PRC_PNP_TRUESEEING))
    {*/
        effect eSight = EffectSeeInvisible();
        int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
        if(nSpot == 0)
            nSpot = 15;
        effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
        effect eUltra = EffectUltravision();
        eSight = EffectLinkEffects(eSight, eSpot);
        eSight = EffectLinkEffects(eSight, eUltra);
        eSight = SupernaturalEffect(eSight);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSight, oPC);
/*    }
    else
        DelayCommand(0.1, IPSafeAddItemProperty(oSkin,ItemPropertyTrueSeeing(),0.0));*/
}

void DoWing(object oPC, int nWingType)
{
    //wing invalid, use current
    if(nWingType == -1) return;
    //no CEP2, no extra wing models
    if(!CEP_IN_USE) return;
    SetNaturalWings(nWingType, oPC);
    //override any stored default appearance
    //SetPersistantLocalInt(oPC,    "AppearanceStoredWing", nWingType);
}

void DoTail(object oPC, int nTailType)
{
    //tail invalid, use current
    if(nTailType == -1) return;
    //no CEP2, no extra tail models
    if(!CEP_IN_USE) return;
    if (GetIsMounted(oPC)) {
        if (GetLocalInt(oPC, "ONENTER")!=1) {
            Horses_disMount(oPC);
            DelayCommand(2.0, SetNaturalTail(nTailType, oPC));
        }
    } else
        SetNaturalTail(nTailType, oPC);
    //override any stored default appearance
    //SetPersistantLocalInt(oPC,    "AppearanceStoredTail", nTailType);
}


void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int dragonType = GetCampaignInt(DraDis_DATABASE, DraDis_DRAGON_TYPE, oPC);
    if (dragonType == 0)
    {
        dragonType = d10();
        SetCampaignInt(DraDis_DATABASE, DraDis_DRAGON_TYPE, dragonType, oPC);
    }

    //Elemental Immunities for various dragon types.
    int iType = -1;
    switch (dragonType) {
        case DRAGON_TYPE_BLACK:          iType = IP_CONST_DAMAGETYPE_ACID; break;
        case DRAGON_TYPE_BLUE:           iType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
        case DRAGON_TYPE_BRASS:          iType = IP_CONST_DAMAGETYPE_FIRE; break;
        case DRAGON_TYPE_BRONZE:         iType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
        case DRAGON_TYPE_COPPER:         iType = IP_CONST_DAMAGETYPE_ACID; break;
        case DRAGON_TYPE_GOLD:           iType = IP_CONST_DAMAGETYPE_FIRE; break;
        case DRAGON_TYPE_GREEN:          iType = IP_CONST_DAMAGETYPE_ACID; break;
        case DRAGON_TYPE_RED:            iType = IP_CONST_DAMAGETYPE_FIRE; break;
        case DRAGON_TYPE_SILVER:         iType = IP_CONST_DAMAGETYPE_COLD; break;
        case DRAGON_TYPE_WHITE:          iType = IP_CONST_DAMAGETYPE_COLD; break;
    }

    int lResis = GetHasFeat(FEAT_PYROCLASTIC_DRAGON, oPC) ? IP_CONST_DAMAGEIMMUNITY_50_PERCENT :
                -1; // If none match, make the itemproperty invalid

    //Random Immunities for various Dragon types.
    int pImmune = GetHasFeat(FEAT_AMETHYST_DRAGON, oPC)   ? IP_CONST_IMMUNITYMISC_POISON :
                  GetHasFeat(FEAT_SONG_DRAGON, oPC)       ? IP_CONST_IMMUNITYMISC_POISON :
                  GetHasFeat(FEAT_STYX_DRAGON, oPC)       ? IP_CONST_IMMUNITYMISC_POISON :
                  GetHasFeat(FEAT_SHEN_LUNG_DRAGON, oPC)  ? IP_CONST_IMMUNITYMISC_POISON :
                  GetHasFeat(FEAT_SHADOW_DRAGON, oPC)     ? IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN :
                   -1; // If none match, make the itemproperty invalid

    int dImmune = GetHasFeat(FEAT_STYX_DRAGON, oPC)       ? IP_CONST_IMMUNITYMISC_DISEASE :
                   -1; // If none match, make the itemproperty invalid

    int iSpell = GetHasFeat(FEAT_DEEP_DRAGON, oPC)        ? IP_CONST_IMMUNITYSPELL_CHARM_PERSON_OR_ANIMAL :
                 GetHasFeat(FEAT_CHAOS_DRAGON, oPC)       ? IP_CONST_IMMUNITYSPELL_CONFUSION :
                 GetHasFeat(FEAT_TIEN_LUNG_DRAGON, oPC)   ? SPELL_DROWN :
                 GetHasFeat(FEAT_LUNG_WANG_DRAGON, oPC)   ? SPELL_DROWN :
                 GetHasFeat(FEAT_CHIANG_LUNG_DRAGON, oPC) ? SPELL_DROWN :
                 GetHasFeat(FEAT_PAN_LUNG_DRAGON, oPC)    ? SPELL_DROWN :
                 GetHasFeat(FEAT_SHEN_LUNG_DRAGON, oPC)   ? SPELL_DROWN :
                 GetHasFeat(FEAT_TUN_MI_LUNG_DRAGON, oPC) ? SPELL_DROWN :
                 GetHasFeat(FEAT_YU_LUNG_DRAGON, oPC)     ? SPELL_DROWN :
                  -1; // If none match, make the itemproperty invalid

    int iSpel2 = GetHasFeat(FEAT_TIEN_LUNG_DRAGON, oPC)   ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_LUNG_WANG_DRAGON, oPC)   ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_CHIANG_LUNG_DRAGON, oPC) ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_PAN_LUNG_DRAGON, oPC)    ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_SHEN_LUNG_DRAGON, oPC)   ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_TUN_MI_LUNG_DRAGON, oPC) ? SPELL_MASS_DROWN :
                 GetHasFeat(FEAT_YU_LUNG_DRAGON, oPC)     ? SPELL_MASS_DROWN :
                  -1; // If none match, make the itemproperty invalid

    int sResis = GetHasFeat(FEAT_DEEP_DRAGON, oPC)        ? IP_CONST_DAMAGERESIST_10 :
                  -1; // If none match, make the itemproperty invalid

    int sCale1 = GetHasFeat(FAST_HEALING_1,oPC);
    int sCale2 = GetHasFeat(FAST_HEALING_2,oPC);

    int nWingType = -1;
    switch (dragonType) {
        case DRAGON_TYPE_BLACK:          nWingType = 34; break;
        case DRAGON_TYPE_BLUE:           nWingType = 35; break;
        case DRAGON_TYPE_BRASS:          nWingType = 36; break;
        case DRAGON_TYPE_BRONZE:         nWingType = 37; break;
        case DRAGON_TYPE_COPPER:         nWingType = 38; break;
        case DRAGON_TYPE_GOLD:           nWingType = 39; break;
        case DRAGON_TYPE_GREEN:          nWingType = 40; break;
        case DRAGON_TYPE_RED:            nWingType = 4; break;
        case DRAGON_TYPE_SILVER:         nWingType = 41; break;
        case DRAGON_TYPE_WHITE:          nWingType = 42; break;
    }

    //dragon disciple lichs get draco-lich wings at lich 4
    if(GetLevelByClass(CLASS_TYPE_LICH, oPC) >= 4) nWingType = 51;

    int nTailType = -1;
    switch (dragonType) {
        case DRAGON_TYPE_BLACK:          nTailType = 166; break;
        case DRAGON_TYPE_BLUE:           nTailType = 167; break;
        case DRAGON_TYPE_BRASS:          nTailType = 171; break;
        case DRAGON_TYPE_BRONZE:         nTailType = 172; break;
        case DRAGON_TYPE_COPPER:         nTailType = 173; break;
        case DRAGON_TYPE_GOLD:           nTailType = 174; break;
        case DRAGON_TYPE_GREEN:          nTailType = 1; break;
        case DRAGON_TYPE_RED:            nTailType = 159; break;
        case DRAGON_TYPE_SILVER:         nTailType = 175; break;
        case DRAGON_TYPE_WHITE:          nTailType = 168; break;
    }

    //dragon disciple lichs get bony tail at lich 4
    if(GetLevelByClass(CLASS_TYPE_LICH, oPC) >= 4) nTailType = 2;

    int nLevel = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE,oPC);

    //natural weapons
    //bite at level 2
    //2 claws at level 2
    //2 wing slam at level 12
    //tail slam at level 17
    if(nLevel >= 2)
    {
        int nSize = GetCreatureSize(oPC);
        if(GetHasFeat(DRACONIC_BITE, oPC))
        {
            string sResRef = "prc_rdd_bite_";
            sResRef += GetAffixForSize(nSize);
            AddNaturalSecondaryWeapon(oPC, sResRef);
            //claw here
            sResRef = "prc_claw_1d6l_";
            sResRef += GetAffixForSize(nSize);
            AddNaturalPrimaryWeapon(oPC, sResRef, 2);
        }
        if(GetHasFeat(DRACONIC_WINGSLAMS, oPC))
        {
            string sResRef = "prc_rdd_wing_";
            sResRef += GetAffixForSize(nSize);
            if(nSize >= CREATURE_SIZE_MEDIUM)
                AddNaturalSecondaryWeapon(oPC, sResRef, 2);
        }
        if(GetHasFeat(DRACONIC_TAILSLAP, oPC))
        {
            string sResRef = "prc_rdd_tail_";
            sResRef += GetAffixForSize(nSize);
            if(nSize >= CREATURE_SIZE_LARGE)
                AddNaturalSecondaryWeapon(oPC, sResRef);
        }
    }


    int thickScale = -1;
    if(GetHasFeat(DRACONIC_ARMOR_AUG_2,oPC))
        thickScale = 2;
    else if(GetHasFeat(DRACONIC_ARMOR_AUG_1,oPC))
        thickScale = 1;

    SetCompositeBonus(oSkin, "ScaleThicken", thickScale, ITEM_PROPERTY_AC_BONUS);

    int bResisEle = GetHasFeat(FEAT_DRACONIC_IMMUNITY, oPC) ? IP_CONST_DAMAGEIMMUNITY_100_PERCENT : 0;

    if (bResisEle>0) ElImmune(oPC,oSkin,bResisEle,iType);
    if (bResisEle>0) PoisImmu(oPC,oSkin,bResisEle,pImmune);
    if (bResisEle>0) DisImmu(oPC,oSkin,bResisEle,dImmune);
    if (bResisEle>0) SpellImmu(oPC,oSkin,bResisEle,iSpell);
    if (bResisEle>0) SpellImmu2(oPC,oSkin,bResisEle,iSpel2);
    if (bResisEle>0) SmallResist(oPC,oSkin,bResisEle,sResis);
    if (bResisEle>0) LargeResist(oPC,oSkin,bResisEle,lResis);
    if (nLevel>17) SpellResis(oPC,oSkin,nLevel);
    if (nLevel>17) DoTail(oPC, nTailType);
    if (nLevel>9)  DoWing(oPC, nWingType);
    if (nLevel>19) SeeTrue(oPC,oSkin,nLevel);
}
