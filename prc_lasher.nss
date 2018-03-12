//::///////////////////////////////////////////////
//:: Lasher
//:://////////////////////////////////////////////
/*
    Script to add lasher bonuses

    Improved Knockdown (Whip)
    Crack of Fate
    Lashing Whip
    Improved Disarm (Whip)
    Crack of Doom

    code "borrowed" from tempest, stormlord,
        soulknife

    modified to allow toggling of crack of fate/doom
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 24, 2005
//:: Modified: May 24, 2006
//:://////////////////////////////////////////////

//compiler would completely crap itself unless this include was here
#include "inc_2dacache"
#include "spinc_common"

void ApplyLashing(object oPC) //ripped off the tempest
{
    if(!GetHasSpellEffect(SPELL_LASHER_LASHW, oPC))
    {
        ActionCastSpellOnSelf(SPELL_LASHER_LASHW);
    }
}

void ApplyBonuses(object oPC, object oWeapon)
{
    object oSkin = GetPCSkin(oPC);
    int iClassLevel = (GetLevelByClass(CLASS_TYPE_LASHER));

    object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    //counters the +2 damage on the offhand weapon
    if(GetIsObjectValid(oOffHand) && oOffHand == oWeapon)
        AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamagePenalty(2), oOffHand, 9999.0);

    string sMessage = "";
    if(GetBaseItemType(oWeapon) != BASE_ITEM_WHIP)  //assumes off-hand can't be whip
        return;
    if(GetLocalInt(oWeapon, "Lasher_Whip_Bonus")) return;

    if(iClassLevel > 1 && !GetHasFeat(FEAT_IMPROVED_KNOCKDOWN))    //improved knockdown (whip)
    {
        IPSafeAddItemProperty(oSkin,
            PRCItemPropertyBonusFeat(IP_CONST_FEAT_KNOCKDOWN)  //for radial inclusion
            );
        IPSafeAddItemProperty(oSkin,
            PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_KNOCKDOWN)
            );
    }

    if(iClassLevel > 3)    //lashing whip
    {
        DelayCommand(0.1, ApplyLashing(oPC));
        //counters the +2 damage on the offhand weapon
        if(GetIsObjectValid(oOffHand))
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamagePenalty(2), oOffHand, 9999.0);
    }

    if(iClassLevel > 5 && !GetHasFeat(FEAT_IMPROVED_DISARM))    //improved disarm (whip)
    {
        IPSafeAddItemProperty(oSkin,
                PRCItemPropertyBonusFeat(IP_CONST_FEAT_DISARM) //in case the whip doesn't have it
                );
        IPSafeAddItemProperty(oSkin,
                PRCItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_DISARM)
                );
    }

    SetLocalInt(oWeapon, "Lasher_Whip_Bonus", 1);
    if(iClassLevel > 2)
        FloatingTextStringOnCreature(sMessage, oPC, FALSE);
}

void RemoveBonuses(object oPC, object oWeapon)
{
    object oSkin = GetPCSkin(oPC);

    object oOffHand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    //counters the +2 damage on the offhand weapon
    RemoveSpecificProperty(oOffHand, ITEM_PROPERTY_DECREASED_DAMAGE, -1, 2, 1, "", -1, DURATION_TYPE_TEMPORARY);
    if(oOffHand == oWeapon)
        return;     //it's the off-hand weapon being equipped here

    int iClassLevel = (GetLevelByClass(CLASS_TYPE_LASHER));
    string sMessage = "";
    if (GetBaseItemType(oWeapon) != BASE_ITEM_WHIP)
        return;

    if(GetLocalInt(oWeapon, "Lasher_Whip_Bonus"))
    {
        if(iClassLevel > 1)    //improved knockdown (whip)
        {
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_IMPROVED_KNOCKDOWN
                );
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_KNOCKDOWN
                );
        }

        if(GetHasSpellEffect(SPELL_LASHER_LASHW, oPC)) //lashing whip
            RemoveEffectsFromSpell(oPC, SPELL_LASHER_LASHW);

        if(iClassLevel > 5)    //improved disarm (whip)
        {
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_IMPROVED_DISARM
                );
            RemoveSpecificProperty(oSkin, ITEM_PROPERTY_BONUS_FEAT,
                IP_CONST_FEAT_DISARM
                );
        }

        if(GetHasSpellEffect(SPELL_LASHER_CRACK_FATE, oPC))
        {
            RemoveEffectsFromSpell(oPC, SPELL_LASHER_CRACK_FATE);
            FloatingTextStringOnCreature("*Crack of Fate Deactivated*", oPC, FALSE);
        }
        if(GetHasSpellEffect(SPELL_LASHER_CRACK_DOOM, oPC))
        {
            RemoveEffectsFromSpell(oPC, SPELL_LASHER_CRACK_DOOM);
            FloatingTextStringOnCreature("*Crack of Doom Deactivated*", oPC, FALSE);
        }

        DeleteLocalInt(oWeapon, "Lasher_Whip_Bonus");
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oWeapon;
    int iEquip = GetLocalInt(oPC,"ONEQUIP");  //2 = equip, 1 = unequip
    int iRest = GetLocalInt(oPC,"ONREST");  //1 = rest finished
    int iEnter = GetLocalInt(oPC,"ONENTER");  //1 = rest finished

    if(iEquip == 2) //OnEquip
    {
        oWeapon = GetPCItemLastEquipped();
        ApplyBonuses(oPC, oWeapon);
    }
    else if (iEquip == 1) //OnUnEquip
    {
        oWeapon = GetPCItemLastUnequipped();
        RemoveBonuses(oPC, oWeapon);
    }
    if(iEnter == 1)
    {
        oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        ApplyBonuses(oPC, oWeapon);
    }

}
