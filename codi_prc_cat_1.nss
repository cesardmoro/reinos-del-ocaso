/*
    Determines value of current masterwork weapon.
*/

// This function is only here for me to test with.

#include "prc_inc_clsfunc"

//void DebugSpeak(object oPC, itemproperty ip, string sString, int iVar = -1);

void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC,"codi_sam_mw");
    int iValue = 0;
    itemproperty ip = GetFirstItemProperty(oWeapon);
    int iPropType;
    int iParam1;
    int iParam1val;
    int iSubType;
    int iCostTable;
    int iCostTableValue;
    while (GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyDurationType(ip) == DURATION_TYPE_PERMANENT)
        {
            iPropType = GetItemPropertyType(ip);
            iParam1 = GetItemPropertyParam1(ip);
            iParam1val = GetItemPropertyParam1Value(ip);
            iSubType = GetItemPropertySubType(ip);
            iCostTable = GetItemPropertyCostTable(ip);
            iCostTableValue = GetItemPropertyCostTableValue(ip);
            switch(iPropType)
            {
            case ITEM_PROPERTY_ABILITY_BONUS:
                iValue += iCostTableValue;
                break;
            case ITEM_PROPERTY_AC_BONUS:
                iValue += iCostTableValue/2;
                break;
            case ITEM_PROPERTY_ATTACK_BONUS:
                iValue += iCostTableValue/2;
                break;
            case ITEM_PROPERTY_ENHANCEMENT_BONUS:
                iValue += iCostTableValue;
                break;
            case ITEM_PROPERTY_CAST_SPELL:
                //DebugSpeak(oPC, ip, "Item Property - On Hit Cast Spell", IP_CONST_ONHIT_CASTSPELL_SILENCE);
            case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
            case ITEM_PROPERTY_KEEN:
            case ITEM_PROPERTY_MASSIVE_CRITICALS:
            case ITEM_PROPERTY_ON_HIT_PROPERTIES:
            case ITEM_PROPERTY_ONHITCASTSPELL:
                //DebugSpeak(oPC, ip, "Item Property - On Hit Cast Spell", IP_CONST_ONHIT_CASTSPELL_SILENCE);
            case ITEM_PROPERTY_REGENERATION:
            case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
            case ITEM_PROPERTY_SPELL_RESISTANCE:
            case ITEM_PROPERTY_DAMAGE_REDUCTION:
            case ITEM_PROPERTY_DAMAGE_RESISTANCE:
            case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
            case ITEM_PROPERTY_HOLY_AVENGER:
            case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
                iValue += 1;
                break;
            case ITEM_PROPERTY_DAMAGE_BONUS:
                //DebugSpeak(oPC, ip, "Item Property - Damage Bonus", IP_CONST_DAMAGEBONUS_1d6);
                switch(iCostTableValue)
                {
                case IP_CONST_DAMAGEBONUS_1d6:
                    iValue += 1;
                    break;
                case IP_CONST_DAMAGEBONUS_2d6:
                    iValue += 2;
                    break;
                case IP_CONST_DAMAGEBONUS_2d12:
                    iValue += 3;
                }
                break;
            case ITEM_PROPERTY_SAVING_THROW_BONUS:
            case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
                iValue += iCostTableValue/2;
                //DebugSpeak(oPC, ip, "Item Property - Saving Throw Bonus");
                break;
            case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
                iValue = iValue - iCostTableValue;
                break;
            case ITEM_PROPERTY_USE_LIMITATION_CLASS:
                iValue = iValue - 1;
                break;
            case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
                iValue += iCostTableValue/2;
                break;
            case ITEM_PROPERTY_SKILL_BONUS:
                iValue += iCostTableValue/4;
                break;
            }
        }
        ip = GetNextItemProperty(oWeapon);
    }

    //AssignCommand(oPC,SpeakString("The weapon is equivalent of +" + IntToString(iValue)));
    string sCost;
    int iCost;
    sCost = IntToString((iValue * 4) + 2) + ",000";
    iCost = (iValue*4 + 2) * 1000;
    SetLocalInt(oPC,"CODI_SAM_WEAPON_VALUE",iValue);
    SetLocalInt(oPC,"CODI_SAM_WEAPON_COST",iCost);
    SetCustomToken(100,sCost);
    object oItem = GetSamuraiToken(oPC);
    if(oItem == OBJECT_INVALID)
    {
        SetCustomToken(101,"0");
        SetLocalInt(oPC,"CODI_SAM_SACRIFICE",0);
    }
    else
    {
        iValue = StringToInt(GetTag(oItem));
        SetCustomToken(101,IntToString(iValue));
        SetLocalInt(oPC,"CODI_SAM_SACRIFICE",iValue);
    }
}

//void DebugSpeak(object oPC, itemproperty ip, string sString, int iVar = -1)
//{
//    AssignCommand(oPC, SpeakString("Property Type: " + IntToString(GetItemPropertyType(ip))));
//    AssignCommand(oPC, SpeakString("Cost Table: " + IntToString(GetItemPropertyCostTable(ip))));
//    AssignCommand(oPC, SpeakString("Cost Table Value: " + IntToString(GetItemPropertyCostTableValue(ip))));
//    AssignCommand(oPC, SpeakString("Duration Type: " + IntToString(GetItemPropertyCostTable(ip))));
//    AssignCommand(oPC, SpeakString("Param1: " + IntToString(GetItemPropertyParam1(ip))));
//    AssignCommand(oPC, SpeakString("Param1 Value: " + IntToString(GetItemPropertyParam1Value(ip))));
//    AssignCommand(oPC, SpeakString("SubType: " + IntToString(GetItemPropertySubType(ip))));
//    if (iVar > -1)
//    {
//        AssignCommand(oPC, SpeakString("Special Variable: " + IntToString(iVar)));
//    }
//}

