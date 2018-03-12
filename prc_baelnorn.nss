//:://///////////////////////////////////////////////////////
//:: Name: Baelnorn Abilities, Properties, and Defense Script
//:: FileName   prc_baelnorn.nss
//:: Copyright (c) 2001 Bioware Corp.
//::////////////////////////////////////////////////////////
//*  Handles the attributes of the Baelnorn.

//*/
//:://////////////////////////////////////////////
//:: Created By:   Mike Adams
//:: Created On:   7/9/2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_inc_function"
#include "x2_inc_itemprop"

//Baelnorn Property bonus function
void BaelnProp (object oSkin, int nBonus)
{
    if (GetLocalInt(oSkin, "BaelnPropSp") == nBonus) return;

    SetCompositeBonus(oSkin, "BaelnPropSp", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPOT);
    SetCompositeBonus(oSkin, "BaelnPropH", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_HIDE);
    SetCompositeBonus(oSkin, "BaelnPropL", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_LISTEN);
    SetCompositeBonus(oSkin, "BaelnPropM", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_MOVE_SILENTLY);
    SetCompositeBonus(oSkin, "BaelnPropS", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_SEARCH);
    SetCompositeBonus(oSkin, "BaelnPropP", nBonus, ITEM_PROPERTY_SKILL_BONUS, SKILL_PERSUADE);
}

//Baelnorn Ability bonus function
void BaelnAbil (object oSkin, int nLevel)
{
    switch(nLevel)
    {
        case 4:
            SetCompositeBonus(oSkin, "BaelnAbilC", 2, ITEM_PROPERTY_ABILITY_BONUS, ABILITY_CHARISMA);
        case 3:
            SetCompositeBonus(oSkin, "BaelnAbilW", 2, ITEM_PROPERTY_ABILITY_BONUS, ABILITY_WISDOM);
        case 2:
        case 1:
            SetCompositeBonus(oSkin, "BaelnAbilI", 2, ITEM_PROPERTY_ABILITY_BONUS, ABILITY_INTELLIGENCE);
            break;
        default:
            WriteTimestampedLogEntry("Unknown nLevel parameter passed to BaelnAbil: " + IntToString(nLevel));
    }
}

//Baelnorn Defense bonus function
void BaelnDef (object oSkin, int nLevel)
{

    SetCompositeBonus(oSkin, "BaelnDefA", nLevel + 1, AC_NATURAL_BONUS, ITEM_PROPERTY_AC_BONUS);

    switch (nLevel)
    {
        case 1:
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_5),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            break;
        case 2:
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_10),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_10),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_5_HP),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            break;
        case 3:
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGERESIST_20),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_20),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_10_HP),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            break;
        case 4:
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEIMMUNITY_100_PERCENT),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGEIMMUNITY_100_PERCENT),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_15_HP),
                                  0.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
            break;

        default:
            WriteTimestampedLogEntry("Unknown nLevel parameter passed to BaelnDef: " + IntToString(nLevel));
    }
}


//main method
void main()
{
	
	//define vars    
	object oPC = OBJECT_SELF;
	object oSkin = GetPCSkin(oPC);
	int nLevel = GetLevelByClass(CLASS_TYPE_BAELNORN, oPC);
	int nBonus = nLevel * 2;
		
	BaelnProp(oSkin, nBonus);
	BaelnAbil(oSkin, nLevel);
	BaelnDef(oSkin, nLevel);
				
	//Eyes
	AssignCommand(oPC, ActionCastSpellAtObject(SPELL_BAELN_EYES, oPC, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
}