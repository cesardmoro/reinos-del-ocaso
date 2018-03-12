///////////////////////////////////////
// Champion of Corellon Larethian
// by LittleDragon
//
// Design of Elegant Strike ability based on Swashbuckler's Insightful strikg
// Didn't add the Elegant Strike's limitation with inmunity to criticals due to personal reasons
//
/////////////////////////////////////

#include "prc_inc_clsfunc"
#include "prc_spell_const"

// Returns wether oWeapon is suited to be used with the Elegant Strike feat
int GetIsAllowedWeaponForElegantStrike( object oWeapon )
{
    int isAllowed = FALSE;
    switch (GetBaseItemType(oWeapon)) {
        case BASE_ITEM_LONGSWORD:   isAllowed = TRUE; break;
        case BASE_ITEM_RAPIER:      isAllowed = TRUE; break;
        case BASE_ITEM_SCIMITAR:    isAllowed = TRUE; break;
        /* Add this if your module has elven weapons
        case BASE_ITEM_ELVENTHINBLADE:     isAllowed = TRUE; break;
        case BASE_ITEM_ELVENCOURTBLADE:    isAllowed = TRUE; break;
        case BASE_ITEM_ELVENLIGHTBLADE:    isAllowed = TRUE; break; */
    }

    return isAllowed;
}

// Adds Dexterity Bonus to damage
void CCorellon_ElegantStrike()
{
    // Allways remove the effects because they stack
    RemoveEffectsFromSpell(OBJECT_SELF, SPELL_CORELLON_DAM);

    object oRightWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    if (GetIsAllowedWeaponForElegantStrike(oRightWeapon))
        ActionCastSpellOnSelf(SPELL_CORELLON_DAM);
}

// Applies a bonus to AC based on dexterity, over the maximum of PC's armor
void CCorellon_SuperiorDefense()
{
    // Allways remove the effects because they stack
    RemoveEffectsFromSpell(OBJECT_SELF, SPELL_CORELLON_AC);
    //ActionCastSpellOnSelf(SPELL_CORELLON_AC);
    ActionCastSpellAtObject(SPELL_CORELLON_AC, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;

    int iElegantStrike = GetHasFeat(ELEGANT_STRIKE, oPC);
    int iSuperiorDefense = GetHasFeat(SUPERIOR_DEFENSE_1, oPC);
    iSuperiorDefense += GetHasFeat(SUPERIOR_DEFENSE_2, oPC);
    iSuperiorDefense += GetHasFeat(SUPERIOR_DEFENSE_3, oPC);
    int iCorellonsWrath = GetHasFeat(CORELLON_WRATH, oPC);

    if (iElegantStrike) AssignCommand(oPC, CCorellon_ElegantStrike());

    if (iSuperiorDefense > 0) AssignCommand(oPC, CCorellon_SuperiorDefense());
}
