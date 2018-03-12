// Favoured Soul passive abilities.
// Resist 3 elements, DR, Weapon Focus/Spec

#include "prc_alterations"
#include "inc_dynconv"

void ResistElement(object oPC, object oSkin, int iLevel, int iType, string sVar)
{
  if(GetLocalInt(oSkin, sVar) == iLevel) return;

  RemoveSpecificProperty(oSkin,ITEM_PROPERTY_DAMAGE_RESISTANCE,iType,GetLocalInt(oSkin, sVar));

  DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageResistance(iType, iLevel), oSkin));
  SetLocalInt(oSkin, sVar, iLevel);
}

void DamageReduction(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "FavouredSoulDR") == iLevel) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION, GetLocalInt(oSkin, "FavouredSoulDR"), IP_CONST_DAMAGESOAK_10_HP, 1, "FavouredSoulDR");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(iLevel, IP_CONST_DAMAGESOAK_10_HP), oSkin);
    SetLocalInt(oSkin, "FavouredSoulDR", iLevel);
}

void SetWings(object oPC)
{
	// Neutral wing type
	int nWings = CREATURE_WING_TYPE_BIRD;
	int nAlign = GetAlignmentGoodEvil(oPC);
	if (nAlign == ALIGNMENT_EVIL) nWings = CREATURE_WING_TYPE_DEMON;
	else if (nAlign == ALIGNMENT_GOOD) nWings = CREATURE_WING_TYPE_ANGEL;
	
	// Only need to do this once
	if (GetCreatureWingType(oPC) == nWings) return;
	
	SetCreatureWingType(nWings, oPC);
}

void main()
{
    	//Declare main variables.
    	object oPC = OBJECT_SELF;
    	object oSkin = GetPCSkin(oPC);
    	string sVar = "FavouredSoulResistElement";
    	int nClass = GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC);
	
    	if (GetHasFeat(FEAT_FAVOURED_SOUL_ACID, oPC))
    	{
    		sVar += "Acid";
    		ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_ACID, sVar);
    	}
    	if (GetHasFeat(FEAT_FAVOURED_SOUL_COLD, oPC))
    	{
    		sVar += "Cold";
    		ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_COLD, sVar);
    	}
    	if (GetHasFeat(FEAT_FAVOURED_SOUL_ELEC, oPC))
    	{
    		sVar += "Elec";
    		ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_ELECTRICAL, sVar);
    	}
    	if (GetHasFeat(FEAT_FAVOURED_SOUL_FIRE, oPC))
    	{
    		sVar += "Fire";
    		ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_FIRE, sVar);
    	}
    	if (GetHasFeat(FEAT_FAVOURED_SOUL_SONIC, oPC))
    	{
    		sVar += "Sonic";
    		ResistElement(oPC, oSkin, IP_CONST_DAMAGERESIST_10, IP_CONST_DAMAGETYPE_SONIC, sVar);
    	}  
    
    	if (nClass >= 17) SetWings(oPC);
    	if (nClass >= 20) DamageReduction(oPC, oSkin, IP_CONST_DAMAGEREDUCTION_3);
    
    	// This ability is gained at level 3
    	if (nClass >= 3)
    	{
    		int nDietyFocus = GetPersistantLocalInt(oPC, "FavouredSoulDietyWeapon");
    		// If they've already chosen a weapon, reapply the feats if they dont have it
    		if (nDietyFocus > 0)
    		{
			int nWeaponFocus = GetFeatByWeaponType(nDietyFocus, "Focus");
			int nWFIprop = FeatToIprop(nWeaponFocus);
			int nWeaponSpec = GetFeatByWeaponType(nDietyFocus, "Specialization");
			int nWSIprop = FeatToIprop(nWeaponSpec);
			
    			if (!GetHasFeat(nWeaponFocus, oPC))    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(nWFIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    			if (!GetHasFeat(nWeaponSpec, oPC) && GetLevelByClass(CLASS_TYPE_FAVOURED_SOUL, oPC) >= 12)    IPSafeAddItemProperty(oSkin, ItemPropertyBonusFeat(nWSIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    		}
    		else
    		{
    			 DelayCommand(1.5, StartDynamicConversation("prc_favsoulweap", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
    		}    
    	}
}
