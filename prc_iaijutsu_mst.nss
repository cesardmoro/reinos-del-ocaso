#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "inc_combat"

///Int Bonus to AC /////////
// * Applies the Iaijutusu Masters AC bonuses as CompositeBonuses on the object's skin.
// * AC bonus is determined by object's int bonus (2x int bonus if epic)
// * iOnOff = TRUE/FALSE
// * iEpic = TRUE/FALSE
// * Code By Aaon Greywolf
void DuelistCannyDefense(object oPC, object oSkin, int iOnOff, int iEpic = FALSE)
{
    int iIntBonus = GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
        iIntBonus = iEpic ? iIntBonus * 2 : iIntBonus;

    if(iOnOff){
        SetCompositeBonus(oSkin, "CannyDefenseBonus", iIntBonus, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != TRUE)
            FloatingTextStringOnCreature("Canny Defense On", oPC);
        SetLocalInt(oPC, "CannyDefense", TRUE);
    }
    else {
        SetCompositeBonus(oSkin, "CannyDefenseBonus", 0, ITEM_PROPERTY_AC_BONUS);
        if(GetLocalInt(oPC, "CannyDefense") != FALSE)
            FloatingTextStringOnCreature("Canny Defense Off", oPC);
        SetLocalInt(oPC, "CannyDefense", FALSE);
   }
}

//Applies Katana Finesse to the character as an effect
void KatanaFinesse(object oPC)
{
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    
    int bKatFin = GetHasFeat(FEAT_KATANA_FINESSE, oPC);
    int bStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
    int bDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int bKatFinBon = (bDex > bStr) ? bDex - bStr : 0;
    int iUseR = FALSE;
    int iUseL = FALSE;

    if(bKatFin && bKatFinBon && GetBaseItemType(oWeap) == BASE_ITEM_KATANA)
    {
        iUseR = TRUE;
        if (!GetLocalInt(oPC, "KatanaFinesseOnR")) FloatingTextStringOnCreature("Katana Finesse On -- Main Hand.", oPC);
        SetLocalInt(oPC, "KatanaFinesseOnR", TRUE);
    }
    else
    {
        if (GetLocalInt(oPC, "KatanaFinesseOnR")) FloatingTextStringOnCreature("Katana Finesse Off -- Main Hand.", oPC);
        DeleteLocalInt(oPC, "KatanaFinesseOnR");
    }
    
    if(bKatFin && bKatFinBon && GetBaseItemType(oWeap2) == BASE_ITEM_KATANA)
    {
        iUseL = TRUE;
        if (!GetLocalInt(oPC, "KatanaFinesseOnL")) FloatingTextStringOnCreature("Katana Finesse On -- Off Hand.", oPC);
        SetLocalInt(oPC, "KatanaFinesseOnL", TRUE);
    }
    else
    {
        if (GetLocalInt(oPC, "KatanaFinesseOnL")) FloatingTextStringOnCreature("Katana Finesse Off -- Off Hand.", oPC);
        DeleteLocalInt(oPC, "KatanaFinesseOnL");
    }

    if (iUseR)
        SetCompositeAttackBonus(oPC, "KatanaFinesseR", bKatFinBon, ATTACK_BONUS_ONHAND);
    if (iUseL)
        SetCompositeAttackBonus(oPC, "KatanaFinesseL", bKatFinBon, ATTACK_BONUS_OFFHAND);
}

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    object oUnequip = GetPCItemLastUnequipped();

    //Determine which feats the character has
    int bCanDef = GetHasFeat(FEAT_CANNY_DEFENSE, oPC);
    int bEpicCD = GetHasFeat(FEAT_EPIC_IAIJUTSU, oPC);
    int bKatFin = GetHasFeat(FEAT_KATANA_FINESSE, oPC);

    //Apply bonuses accordingly
    if(bCanDef > 0 && GetBaseAC(oArmor) == 0)
        DuelistCannyDefense(oPC, oSkin, TRUE, bEpicCD);
    else
        DuelistCannyDefense(oPC, oSkin, FALSE);

    int bStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
    int bDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
    int bKatFinBon = (bDex > bStr) ? bDex - bStr : 0;

    SetCompositeAttackBonus(oPC, "KatanaFinesseR", 0, ATTACK_BONUS_ONHAND);
    SetCompositeAttackBonus(oPC, "KatanaFinesseL", 0, ATTACK_BONUS_OFFHAND);

    KatanaFinesse(oPC);
}
