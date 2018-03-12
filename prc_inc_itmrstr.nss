/*

    This include governs all the new itemproperties
    Both restrictions and features



*/

const string PLAYER_SPEED_INCREASE = "player_speed_increase";
const string PLAYER_SPEED_DECREASE = "player_speed_decrease";

void ApplySpeedIncrease(object oPC);
void ApplySpeedDecrease(object oPC);
int DoUMDCheck(object oItem, object oPC, int nDCMod);
int CheckPRCLimitations(object oItem, object oPC);
void CheckForPnPHolyAvenger(object oItem);

#include "inc_utility"
#include "prc_inc_newip"

//credit to silvercloud for this :)
void ApplySpeedIncrease(object oPC)
{
    int nSpeedMod = GetLocalInt(oPC, PLAYER_SPEED_INCREASE);
    //clean existing modification
    effect eTest = GetFirstEffect(oPC);

    while(GetIsEffectValid(eTest))
    {
        if(GetEffectCreator(eTest) == OBJECT_SELF
           && GetEffectType(eTest) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE
           && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL
           )
            RemoveEffect(oPC, eTest);
        eTest = GetNextEffect(oPC);
    }
    //add new modification
    if (nSpeedMod > 0)
    {
        // when applying start above 100%, since 100% equals base speed
        nSpeedMod += 100;

        effect eSpeedMod = SupernaturalEffect(EffectMovementSpeedIncrease(nSpeedMod));
                DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeedMod, oPC));
    }
}

//credit to silvercloud for this :)
void ApplySpeedDecrease(object oPC)
{
    int nSpeedMod = GetLocalInt(oPC, PLAYER_SPEED_DECREASE);
    //clean existing modification
    effect eTest = GetFirstEffect(oPC);
    while(GetIsEffectValid(eTest))
    {
        if(GetEffectCreator(eTest) == OBJECT_SELF
           && GetEffectType(eTest) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
           && GetEffectSubType(eTest) == SUBTYPE_SUPERNATURAL
           )
            RemoveEffect(oPC, eTest);
        eTest = GetNextEffect(oPC);
    }
    //add new modification
    if (nSpeedMod > 0)
    {
        //setting a decrease over 99 doesnt work
        if (nSpeedMod > 99) nSpeedMod = 99;

        effect eSpeedMod = SupernaturalEffect(EffectMovementSpeedDecrease(nSpeedMod));
        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeedMod, oPC));
    }
}

int GetUMDForItemCost(object oItem)
{
    string s2DAEntry;
    int nValue = GetGoldPieceValue(oItem);
    int n2DAValue = StringToInt(s2DAEntry);
    int i;
    while(n2DAValue < nValue)
    {
        s2DAEntry = Get2DACache("skillvsitemcost", "DeviceCostMax", i);
        n2DAValue = StringToInt(s2DAEntry);
        i++;
    }
    i--;
    string s2DAReqSkill = Get2DACache("skillvsitemcost", "SkillReq_Class", i);
    if(s2DAReqSkill == "")
        return -1;
    return StringToInt(s2DAReqSkill);
}

//this is a scripted version of the bioware UMD check for using restricted items
//this also applies effects relating to new itemproperties
int DoUMDCheck(object oItem, object oPC, int nDCMod)
{

    //doesnt have UMD
    if(!GetHasSkill(SKILL_USE_MAGIC_DEVICE, oPC))
        return FALSE;

    int nSkill = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC);
    int nReqSkill = GetUMDForItemCost(oItem);
    //class is a dc20 test
    nReqSkill = nReqSkill - 20 + nDCMod;
    if(nReqSkill > nSkill)
        return FALSE;
    else
        return TRUE;
}
void VoidCheckPRCLimitations(object oItem, object oPC)
{
    CheckPRCLimitations(oItem, oPC);
}

//tests for use restrictions
//also appies effects for those IPs tat need them
int CheckPRCLimitations(object oItem, object oPC)
{
    //sanity checks
    if(!GetIsObjectValid(oPC))
        oPC = GetItemPossessor(oItem);

    itemproperty ipTest = GetFirstItemProperty(oItem);
    int bPass = TRUE;
    int nUMDDC;
    int nSpeedIncrease = GetLocalInt(oPC, PLAYER_SPEED_INCREASE);
    int nSpeedDecrease = GetLocalInt(oPC, PLAYER_SPEED_DECREASE);
    object oSkin = GetPCSkin(oPC);

    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_ABILITY_SCORE)
        {
            int nValue = GetItemPropertyCostTableValue(ipTest);
            int nAbility = GetItemPropertySubType(ipTest);
            object oHide = GetPCSkin(oPC);
            int nTrueValue;
            switch(nAbility)
            {
                case ABILITY_STRENGTH:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueSTR");
                    break;
                case ABILITY_DEXTERITY:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueDEX");
                    break;
                case ABILITY_CONSTITUTION:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueCON");
                    break;
                case ABILITY_INTELLIGENCE:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueINT");
                    break;
                case ABILITY_WISDOM:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueWIS");
                    break;
                case ABILITY_CHARISMA:
                    nTrueValue = GetLocalInt(oHide, "PRC_trueCHA");
                    break;
            }
            if(nTrueValue < nValue)
                bPass = FALSE;
            nUMDDC += nValue-15;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_SKILL_RANKS)
        {
            int nValue = GetItemPropertyCostTableValue(ipTest);
            int nSkill = GetItemPropertySubType(ipTest);
            int nTrueValue = GetSkillRank(nSkill, oPC);
            if(nTrueValue < nValue)
                bPass = FALSE;
            nUMDDC += nValue-10;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_SPELL_LEVEL)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_AllSpell"+IntToString(nLevel));
            if(nValid)
                bPass = FALSE;
            nUMDDC += (nLevel*2)-20;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_ARCANE_SPELL_LEVEL)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_ArcSpell"+IntToString(nLevel));
            if(nValid)
                bPass = FALSE;
            nUMDDC += (nLevel*2)-20;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_DIVINE_SPELL_LEVEL)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_DivSpell"+IntToString(nLevel));
            if(nValid)
                bPass = FALSE;
            nUMDDC += (nLevel*2)-20;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_SNEAK_ATTACK)
        {
            int nLevel = GetItemPropertyCostTableValue(ipTest);
            int nValid = GetLocalInt(oPC, "PRC_SneakLevel"+IntToString(nLevel));
            if(nValid)
                bPass = FALSE;
            nUMDDC += (nLevel*2)-20;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_USE_LIMITATION_GENDER)
        {
            int nIPGender = GetItemPropertySubType(ipTest);
            int nRealGender = GetGender(oPC);
            if(nRealGender != nIPGender)
                bPass = FALSE;
            nUMDDC += 5;
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_SPEED_INCREASE)
        {
            int iItemAdjust = 0;
            int nCost = GetItemPropertyCostTableValue(ipTest);
            switch(nCost)
            {
                case 0: iItemAdjust = 10; break;
                case 1: iItemAdjust = 20; break;
                case 2: iItemAdjust = 30; break;
                case 3: iItemAdjust = 40; break;
                case 4: iItemAdjust = 50; break;
                case 5: iItemAdjust = 60; break;
                case 6: iItemAdjust = 70; break;
                case 7: iItemAdjust = 80; break;
                case 8: iItemAdjust = 90; break;
                case 9: iItemAdjust = 100; break;
            }
            if(GetItemLastUnequipped() == oItem) //unequip event
                nSpeedDecrease -= iItemAdjust;
            else
                nSpeedIncrease += iItemAdjust;
            SetLocalInt(oPC, PLAYER_SPEED_INCREASE, nSpeedIncrease);
            AssignCommand(oSkin, ApplySpeedIncrease(oPC));
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_SPEED_DECREASE)
        {
            int iItemAdjust = 0;
            int nCost = GetItemPropertyCostTableValue(ipTest);
            switch(nCost)
            {
                case 0: iItemAdjust = 10; break;
                case 1: iItemAdjust = 20; break;
                case 2: iItemAdjust = 30; break;
                case 3: iItemAdjust = 40; break;
                case 4: iItemAdjust = 50; break;
                case 5: iItemAdjust = 60; break;
                case 6: iItemAdjust = 70; break;
                case 7: iItemAdjust = 80; break;
                case 8: iItemAdjust = 90; break;
                case 9: iItemAdjust = 99; break;
            }
            if(GetItemLastUnequipped() == oItem) //unequip event
                nSpeedDecrease -= iItemAdjust;
            else
                nSpeedDecrease += iItemAdjust;
            SetLocalInt(oPC, PLAYER_SPEED_DECREASE, nSpeedDecrease);
            AssignCommand(oSkin, ApplySpeedDecrease(oPC));
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_PNP_HOLY_AVENGER)
        {
            if(GetItemLastUnequipped() == oItem) //unequip event
            {
                int nPaladinLevels = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
                if(!nPaladinLevels)
                {
                    //not a paladin? fake it
                    //not really a true PnP test
                    //instead it sets the paladin level
                    //to the UMD ranks minus the amount required
                    //to use a class restricted item of that value
                    int nSkill = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC);
                    if(nSkill)
                    {
                        int nReqSkill = GetUMDForItemCost(oItem);
                        nSkill -= nReqSkill;
                        if(nSkill > 0)
                            nPaladinLevels = nSkill;
                    }
                }
                if(nPaladinLevels)
                {
                    DelayCommand(0.1, IPSafeAddItemProperty(oItem,
                        ItemPropertyEnhancementBonus(5), 99999.9));
                    DelayCommand(0.1, IPSafeAddItemProperty(oItem,
                        ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,
                            IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), 99999.9));
                    //this is a normal dispel magic useage, should be specific
                    DelayCommand(0.1, IPSafeAddItemProperty(oItem,
                        ItemPropertyCastSpell(IP_CONST_CASTSPELL_DISPEL_MAGIC_5,
                            IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE), 99999.9));
                    DelayCommand(0.1, IPSafeAddItemProperty(oItem,
                        ItemPropertyCastSpellCasterLevel(SPELL_DISPEL_MAGIC,
                            nPaladinLevels), 99999.9));
                }
                else
                {
                    DelayCommand(0.1, IPSafeAddItemProperty(oItem,
                        ItemPropertyEnhancementBonus(2), 99999.9));
                }
            }
            else
            {
                IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS,
                    DURATION_TYPE_TEMPORARY, -1);
                IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP,
                    DURATION_TYPE_TEMPORARY, IP_CONST_ALIGNMENTGROUP_EVIL);
                IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CAST_SPELL,
                    DURATION_TYPE_TEMPORARY);
                IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_CAST_SPELL_CASTER_LEVEL,
                    DURATION_TYPE_TEMPORARY);
            }
        }
        else if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_AREA_OF_EFFECT)
        {
            int nSubType  = GetItemPropertySubType(ipTest);
            int nCost     = GetItemPropertyCostTable(ipTest);
            int nAoEID    = StringToInt(Get2DACache("iprp_aoe", "AoEID", nSubType));
            string sEnter = Get2DACache("iprp_aoe", "EnterScript", nSubType);
            string sExit = Get2DACache("iprp_aoe", "ExitScript", nSubType);
            string sHB = Get2DACache("iprp_aoe", "HBScript", nSubType);
            //clean existing modification
            effect eTest = GetFirstEffect(oPC);

            while(GetIsEffectValid(eTest))
            {
                if(GetEffectCreator(eTest) == oItem
                   && GetEffectType(eTest) == EFFECT_TYPE_AREA_OF_EFFECT)
                {
                    RemoveEffect(oPC, eTest);
                    DoDebug("Removing old AoE effect");
                }
                eTest = GetNextEffect(oPC);
            }

            AssignCommand(oItem,
                ApplyEffectToObject(DURATION_TYPE_PERMANENT,
                    EffectAreaOfEffect(nAoEID, sEnter, sHB, sExit),
                        oPC));
            //wont get AoE if its directly ontop of it
            location lLoc = GetLocation(oPC);
            vector vPos = GetPositionFromLocation(lLoc);
            vPos.x += 0.001;
            lLoc = Location(GetAreaFromLocation(lLoc), vPos, 0.0);
            //get te Aoe Object we just created
            int i=1;
            object oAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lLoc, i);
            if(!GetIsObjectValid(oAoE))
                SendMessageToPC(oPC, "No AoE objects detected");
            else
            {
                while(GetAreaOfEffectCreator(oAoE) != oItem
                    && GetIsObjectValid(oAoE))
                {
                    i++;
                    oAoE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lLoc, i);
                }
                if(!GetIsObjectValid(oAoE))
                    DoDebug("Unable to detect AoE created by "+GetName(oItem));
                else
                {
                    SetLocalInt(oAoE, PRC_CASTERLEVEL_OVERRIDE, nCost);
DoDebug("AoE is level "+IntToString(nCost));
                }
            }

        }
        ipTest = GetNextItemProperty(oItem);
    }
    if(!bPass)
        bPass = DoUMDCheck(oItem, oPC, nUMDDC);
    return bPass;
}

void CheckForPnPHolyAvenger(object oItem)
{
    if(!GetPRCSwitch(PRC_PNP_HOLY_AVENGER_IPROP))
        return;
    itemproperty ipTest = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_HOLY_AVENGER)
        {
            DelayCommand(0.1, RemoveItemProperty(oItem, ipTest));
            DelayCommand(0.1, IPSafeAddItemProperty(oItem, ItemPropertyPnPHolyAvenger()));
        }
        ipTest = GetNextItemProperty(oItem);
    }
}