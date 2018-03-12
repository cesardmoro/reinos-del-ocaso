//::///////////////////////////////////////////////
//:: Fist of Hextor
//:: prc_hextor.nss
//:://////////////////////////////////////////////
//:: Applies Fist of Hextor Bonuses
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: April 20, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_inc_clsfunc"

/// Applies the Fist of Hextor Damage ///
void AddBrutalStrikeDam(object oPC)
{
    int iDam;

    if (GetHasFeat(FEAT_BSTRIKE_D12, oPC))
    {
    iDam = DAMAGE_BONUS_12;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D11, oPC))
    {
    iDam = DAMAGE_BONUS_11;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D10, oPC))
    {
    iDam = DAMAGE_BONUS_10;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D9, oPC))
    {
    iDam = DAMAGE_BONUS_9;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D8, oPC))
    {
    iDam = DAMAGE_BONUS_8;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D7, oPC))
    {
    iDam = DAMAGE_BONUS_7;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D6, oPC))
    {
    iDam = DAMAGE_BONUS_6;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D5, oPC))
    {
    iDam = DAMAGE_BONUS_5;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D4, oPC))
    {
    iDam = DAMAGE_BONUS_4;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D3, oPC))
    {
    iDam = DAMAGE_BONUS_3;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D2, oPC))
    {
    iDam = DAMAGE_BONUS_2;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_D1, oPC))
    {
    iDam = DAMAGE_BONUS_1;
    }

    SetLocalInt(oPC, "HexBSDam", iDam);
    DelayCommand(0.1, ActionCastSpellOnSelf(SPELL_HEXTOR_DAMAGE));
    DelayCommand(1.2, DeleteLocalInt(oPC, "HexBSDam"));
}


/// Applies the Fist of Hextor Attack ///
void AddBrutalStrikeAtk(object oPC)
{
    int iAtk;

    if (GetHasFeat(FEAT_BSTRIKE_A12, oPC))
    {
    iAtk = 12;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A11, oPC))
    {
    iAtk = 11;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A10, oPC))
    {
    iAtk = 10;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A9, oPC))
    {
    iAtk = 9;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A8, oPC))
    {
    iAtk = 8;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A7, oPC))
    {
    iAtk = 7;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A6, oPC))
    {
    iAtk = 6;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A5, oPC))
    {
    iAtk = 5;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A4, oPC))
    {
    iAtk = 4;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A3, oPC))
    {
    iAtk = 3;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A2, oPC))
    {
    iAtk = 2;
    }
    else if (GetHasFeat(FEAT_BSTRIKE_A1, oPC))
    {
    iAtk = 1;
    }

    //if(GetLocalInt(oPC, "HexBSAtk") == iAtk) return;
    SetCompositeAttackBonus(oPC, "HexBrutStrikeAtk", iAtk);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    SetCompositeAttackBonus(oPC, "HexBrutStrikeAtk", 0);

    if (GetHasFeat(FEAT_BSTRIKE_D1, oPC)) AddBrutalStrikeDam(oPC);
    if (GetHasFeat(FEAT_BSTRIKE_A1, oPC)) AddBrutalStrikeAtk(oPC);
}
