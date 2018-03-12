// Written by Stratovarius
// Applies the cast domain feats to the hide

#include "prc_inc_domain"
#include "inc_dynconv"

void AddDomainPower(object oPC, object oSkin)
{
    if (GetHasFeat(FEAT_BONUS_DOMAIN_AIR, oPC))           IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_AIR_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_ANIMAL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DEATH, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DEATH_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DESTRUCTION, oPC))   IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DESTRUCTION_DOMAIN), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_EARTH, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EARTH_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_EVIL, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EVIL_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FIRE, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FIRE_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_GOOD, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GOOD_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_HEALING, oPC))       IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HEALING_DOMAIN    ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_KNOWLEDGE, oPC))     IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_KNOWLEDGE_DOMAIN  ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MAGIC_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PLANT, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PLANT_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PROTECTION, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PROTECTION_DOMAIN ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_STRENGTH, oPC))      IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_STRENGTH_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SUN, oPC))           IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SUN_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TRAVEL, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TRAVEL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY, oPC))      IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TRICKERY_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_WAR, oPC))           IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WAR_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_WATER, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WATER_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DARKNESS, oPC))      IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DARKNESS_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_STORM, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_STORM_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_METAL, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_METAL_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PORTAL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FORCE_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SLIME, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SLIME_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TYRANNY, oPC))       IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TYRANNY_DOMAIN    ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DOMINATION, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DOMINATION_DOMAIN ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SPIDER_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_UNDEATH, oPC))       IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNDEATH_DOMAIN    ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TIME, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TIME_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_DWARF, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_DWARF_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_CHARM, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_CHARM_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ELF, oPC))           IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_ELF_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FAMILY, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FAMILY_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FATE, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FATE_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_GNOME, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GNOME_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ILLUSION, oPC))      IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_ILLUSION_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_HATRED, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HATRED_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_HALFLING, oPC))      IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_HALFLING_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_NOBILITY, oPC))      IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_NOBILITY_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_OCEAN_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ORC, oPC))           IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_ORC_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_RENEWAL, oPC))       IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RENEWAL_DOMAIN    ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_RETRIBUTION, oPC))   IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RETRIBUTION_DOMAIN), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_RUNE, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RUNE_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SPELLS, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SPELLS_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCALEYKIND_DOMAIN ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_BLIGHTBRINGER, oPC)) IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLIGHTBRINGER     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
}

void AddDomainFeat(object oPC, object oSkin)
{

    if(DEBUG) FloatingTextStringOnCreature("Add Domain Feat is running", oPC, FALSE);

    if (GetHasFeat(FEAT_DOMAIN_POWER_DARKNESS, oPC))      IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_BLINDFIGHT        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_DOMAIN_POWER_DWARF, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GREAT_FORTITUDE   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_DOMAIN_POWER_ELF, oPC))           IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_POINTBLANK        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_DOMAIN_POWER_FATE, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_UNCANNY_DODGE1    ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_DOMAIN_POWER_RUNE, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCRIBE_SCROLL     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_DOMAIN_POWER_TIME, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_INIT     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_DOMAIN_POWER_UNDEATH, oPC))       IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EXTRA_TURNING     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_DOMAIN_POWER_DOMINATION, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SPELLFOCUSENC     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    
    // +2 Conc and Spellcraft
    if (GetHasFeat(FEAT_DOMAIN_POWER_SPELLS, oPC))
    {
    	if(GetLocalInt(oSkin, "SpellDomainPowerConc") == 2) return;
    
    	SetCompositeBonus(oSkin, "SpellDomainPowerConc", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
    	SetCompositeBonus(oSkin, "SpellDomainPowerSpell", 2, ITEM_PROPERTY_SKILL_BONUS, SKILL_SPELLCRAFT);
    }
    // Electrical resist 5
    if (GetHasFeat(FEAT_DOMAIN_POWER_STORM, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_STORM_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    {
	if(GetLocalInt(oSkin, "StormDomainPower")) return;

	RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_RESISTANCE, IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5);
	AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5),oSkin);
	SetLocalInt(oSkin, "StormDomainPower",TRUE);
    }     
    if (GetHasFeat(FEAT_WAR_DOMAIN_POWER, oPC))
    {
    	int nWarFocus = GetPersistantLocalInt(oPC, "WarDomainWeaponPersistent");
    	// If they've already chosen a weapon, reapply the feats if they dont have it
    	if (nWarFocus > 0)
    	{
    		int nWarWFIprop = FeatToIprop(nWarFocus);
    		if (!GetHasFeat(nWarFocus, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nWarWFIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    		if (!GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    	}
    	else
    	{
    		 DelayCommand(1.5, StartDynamicConversation("prc_domain_war", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
    	}
    		
    }
    if (GetHasFeat(FEAT_DOMAIN_POWER_METAL, oPC))
    {
    	int nWFocus = GetPersistantLocalInt(oPC, "MetalDomainWeaponPersistent");
    	// If they've already chosen a weapon, reapply the feats if they dont have it
    	if (nWFocus > 0)
    	{
    		int nWFIprop = FeatToIprop(nWFocus);
    		if (!GetHasFeat(nWFocus, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(nWFIprop), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    		if (!GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_MARTIAL), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    	}
    	else
    	{
    		 DelayCommand(1.5, StartDynamicConversation("prc_domain_metal", oPC, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oPC));
    	}
    		
    }    
/*
    // Domain powers that need to be created
    if (GetHasFeat(FEAT_BONUS_DOMAIN_RETRIBUTION, oPC))   IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_RETRIBUTION_DOMAIN), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_ANIMAL, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_ANIMAL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
            
    // Domain Powers that grant Turning or something affecting Turning
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SCALEYKIND, oPC))    IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SCALEYKIND_DOMAIN ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SLIME, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SLIME_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_SPIDER, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_SPIDER_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_AIR, oPC))           IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_AIR_DOMAIN        ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_EARTH, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EARTH_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FIRE, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FIRE_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PLANT, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PLANT_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_WATER, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_WATER_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    
    // Domains below here do not have possible Domain Powers in NWN
    if (GetHasFeat(FEAT_BONUS_DOMAIN_PORTAL, oPC))        IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_PORTAL_DOMAIN     ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_OCEAN, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_OCEAN_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_FORCE, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_FORCE_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_MAGIC, oPC))         IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_MAGIC_DOMAIN      ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_TRICKERY, oPC))      IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_TRICKERY_DOMAIN   ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    // For the moment, needs spells to have descriptors
    if (GetHasFeat(FEAT_BONUS_DOMAIN_EVIL, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_EVIL_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
    if (GetHasFeat(FEAT_BONUS_DOMAIN_GOOD, oPC))          IPSafeAddItemProperty(oSkin, PRCItemPropertyBonusFeat(IP_CONST_FEAT_GOOD_DOMAIN       ), 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
*/
}


void main()
{

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    if(DEBUG) FloatingTextStringOnCreature("PRC Domain Skin is running", oPC, FALSE);
    
    // This is above the check to stop because AddDomainFeat needs this to run beforehand.
    // Puts the domain power feats on the skin for the appropriate domains.
    AddDomainPower(oPC, oSkin);    
    
    // This is above the check to stop because all domains, including ones pick at level of a cleric use this
    // Puts the bonus feats that some domains grant on the skin for the appropriate domains.
    AddDomainFeat(oPC, oSkin);    
    
    // Stops the script from running if the PC has no bonus domains
    // Looks in the first slot for a bonus domain, exits if there is none
    // The first domain begins at 1
    if (GetBonusDomain(oPC, 1) <= 0)
    {
    	if(DEBUG) FloatingTextStringOnCreature("You have no bonus domains, exiting prc_domain_skin", oPC, FALSE);
    	return;
    }

    // The prereq variables use 0 as true and 1 as false, becuase they are used in class prereqs
    // It uses allspell because there are some feats that allow a wizard or other arcane caster to take domains.
    if (!GetHasFeat(FEAT_CHECK_DOMAIN_SLOTS))
    {
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CHECK_DOMAIN_SLOTS),oSkin);
        if(DEBUG) FloatingTextStringOnCreature("The PC does not have Check Domain Slots, adding", oPC, FALSE);
    }
    if (GetLocalInt(oPC, "PRC_AllSpell1") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_ONE))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_ONE),oSkin);
    if (GetLocalInt(oPC, "PRC_AllSpell2") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_TWO))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_TWO),oSkin);
    if (GetLocalInt(oPC, "PRC_AllSpell3") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_THREE))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_THREE),oSkin);
    if (GetLocalInt(oPC, "PRC_AllSpell4") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_FOUR))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_FOUR),oSkin);
    if (GetLocalInt(oPC, "PRC_AllSpell5") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_FIVE))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_FIVE),oSkin);
    if (GetLocalInt(oPC, "PRC_AllSpell6") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_SIX))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_SIX),oSkin);
    if (GetLocalInt(oPC, "PRC_AllSpell7") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_SEVEN))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_SEVEN),oSkin);
    if (GetLocalInt(oPC, "PRC_AllSpell8") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_EIGHT))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_EIGHT),oSkin);
    if (GetLocalInt(oPC, "PRC_AllSpell9") == 0 && !GetHasFeat(FEAT_CAST_DOMAIN_LEVEL_NINE))
        AddItemProperty(DURATION_TYPE_PERMANENT,PRCItemPropertyBonusFeat(IP_CONST_FEAT_CAST_DOMAIN_LEVEL_NINE),oSkin);
}