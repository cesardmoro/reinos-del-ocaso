////////////////////////
// 27/04/07 Script By Dragoncin
//
// Aplica los poderes de los Dominios de los clerigos
////////////////

#include "prc_feat_const"
#include "x2_inc_itemprop"
#include "LetoCommands_inc"
#include "Deity_include"
#include "Item_inc"

// Esta funcion se retrasa para esperar que el PRC cree la piel del PJ
void Dominios_applyDomainPowers_step2( object oPC )
{
    object skinPJ = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

    if (GetHasFeat(FEAT_DOMAIN_POWER_STORM, oPC)) {
        itemproperty ipResistirRayo = ItemPropertyDamageResistance(DAMAGE_TYPE_ELECTRICAL, IP_CONST_DAMAGERESIST_5);
        IPSafeAddItemProperty(skinPJ, ipResistirRayo);
    }

    if (GetHasFeat(FEAT_DOMAIN_POWER_SPELLS, oPC)) {
        itemproperty ipConcentracion = ItemPropertySkillBonus(SKILL_CONCENTRATION, 2);
        IPSafeAddItemProperty(skinPJ, ipConcentracion);
        itemproperty ipSpellcraft = ItemPropertySkillBonus(SKILL_SPELLCRAFT, 2);
        IPSafeAddItemProperty(skinPJ, ipSpellcraft);
    }
}

// Esta funcion debe ser llamada desde el evento OnEnter
// Aplica los poderes de los dominios de poder que no estan implementados por Feat
void Domains_applyDomainPowers( object oPC );
void Domains_applyDomainPowers( object oPC )
{

    // Esta funcion se retrasa para esperar que el PRC cree la piel del PJ
    DelayCommand(4.0, Dominios_applyDomainPowers_step2( oPC ));

    if (GetHasFeat(FEAT_DARKNESS_DOMAIN, oPC) && !GetHasFeat(FEAT_BLIND_FIGHT, oPC)) {
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_BLIND_FIGHT));
    }

    if (GetHasFeat(FEAT_DOMAIN_POWER_UNDEATH, oPC) && !GetHasFeat(FEAT_EXTRA_TURNING, oPC)) {
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_EXTRA_TURNING));
    }

    if (GetHasFeat(FEAT_DOMAIN_POWER_TIME, oPC) && !GetHasFeat(FEAT_IMPROVED_INITIATIVE, oPC)) {
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_IMPROVED_INITIATIVE));
    }

    if (GetHasFeat(FEAT_DOMAIN_POWER_DWARF, oPC) && !GetHasFeat(FEAT_GREAT_FORTITUDE, oPC)) {
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_GREAT_FORTITUDE));
    }

    if (GetHasFeat(FEAT_DOMAIN_POWER_ELF, oPC) && !GetHasFeat(FEAT_POINT_BLANK_SHOT, oPC)) {
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_POINT_BLANK_SHOT));
    }

    if (GetHasFeat(FEAT_DOMAIN_POWER_FATE, oPC) && !GetHasFeat(FEAT_UNCANNY_DODGE_1, oPC)) {
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_UNCANNY_DODGE_1));
    }

    if (GetHasFeat(FEAT_DOMAIN_POWER_RUNE, oPC) && !GetHasFeat(FEAT_SCRIBE_SCROLL, oPC)) {
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_SCRIBE_SCROLL));
    }

    if (GetHasFeat(FEAT_WAR_DOMAIN_POWER, oPC) && CheckClericDomains(oPC, GetDeityIndex(oPC)))
    {
        int deityWeapon = GetDeityWeapon(GetDeityIndex(oPC));
		SendMessageToPC( oPC, "DEBUG: deityWeapon= "+IntToString(deityWeapon) );
        int deityWeaponFocusFeat = Item_GetWeaponFocusFeat( deityWeapon );
		SendMessageToPC( oPC, "DEBUG: deityWeaponFocusFeat= "+IntToString(deityWeaponFocusFeat) );
        if (!GetHasFeat(deityWeaponFocusFeat, oPC))
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(deityWeaponFocusFeat));
        int deityWeaponProficiencyFeat = (deityWeapon==BASE_ITEM_DWARVENWARAXE) ? FEAT_WEAPON_PROFICIENCY_MARTIAL : Item_GetWeaponProficiencyNeeded_v1( deityWeapon );
        if (!GetHasFeat(deityWeaponProficiencyFeat, oPC) && deityWeaponProficiencyFeat > -1)
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(deityWeaponProficiencyFeat));
    }

}

// Esto debe llamarse en el evento OnDying para el funcionamiento del Dominio Retribucion
void RetributionDomain_onDying( object oPC );
void RetributionDomain_onDying( object oPC )
{
    if (GetHasFeat(FEAT_DOMAIN_POWER_RENEWAL)) {
        object skinPJ = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

        if (GetLocalInt(skinPJ, "RetributionDomainUsed")!=1) {
            int nCurar = d8(2) + GetAbilityModifier(ABILITY_CHARISMA, oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nCurar), oPC);
            SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_RESTORATION, FALSE));
            FloatingTextStringOnCreature("Tu dios te salva de las garras de la muerte a traves del dominio de la renovacion", oPC, FALSE);
        }
        SetLocalInt(skinPJ, "RetributionDomainUsed", 1);
    }
}

// Esto debe llamarse en el evento OnPlayerRest para el funcionamiento del Dominio Retribucion
void RetributionDomain_onRest( object oPC );
void RetributionDomain_onRest( object oPC )
{
    if (GetHasFeat(FEAT_DOMAIN_POWER_RENEWAL)) {
        object skinPJ = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
        SetLocalInt(skinPJ, "RetributionDomainUsed", 1);
    }
}
