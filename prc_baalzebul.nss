#include "inc_item_props"
#include "prc_feat_const"

//King of Lies +4 Bonus to Cha
void KingofLies(object oPC ,object oSkin ,int iLevel)
{

  if(GetLocalInt(oSkin, "KingofLies") == iLevel) return;

    SetCompositeBonus(oSkin, "KingofLies", iLevel, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CHA);

}

//Int Modifier applied to Bluff Checks aswell as Charisma
void DevilTongue(object oPC ,object oSkin ,int iLevel)
{

   if(GetLocalInt(oSkin, "TongueoftheDevil") == iLevel) return;

    SetCompositeBonus(oSkin, "TongueoftheDevil", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);

}

void main()
{

 //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    int iInt = GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);

    int bKing = GetHasFeat(FEAT_KING_LIES, oPC) ? 4 : 0;
    int bDevil = GetHasFeat(FEAT_TONGUE_DEVIL, oPC) ? iInt : 0;

    if (bKing>0)   KingofLies(oPC, oSkin,bKing);
    if (bDevil>0) DevilTongue(oPC, oSkin,bDevil);

}
