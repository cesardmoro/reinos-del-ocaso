#include "prc_inc_clsfunc"
#include "inc_item_props"
#include "prc_feat_const"
#include "nw_i0_spells"
#include "inc_combat2"

void Equip(object oPC,int bBowSpec,object oSkin,int bXShot)
{
  object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

  int iType = GetBaseItemType(oWeap);

  if (!(iType == BASE_ITEM_LONGBOW ||iType == BASE_ITEM_SHORTBOW )) return;

    SetCompositeAttackBonus(oPC, "ArcherBowSpec", bBowSpec);

  if (bXShot && !GetHasSpellEffect(SPELL_EXTRASHOT,oPC))
  {
     ActionCastSpellOnSelf(SPELL_EXTRASHOT);
  }

}

void UnEquip(object oPC,int bBowSpec,object oSkin,int bXShot)
{
  object oWeap = GetPCItemLastUnequipped();
  int iType = GetBaseItemType(oWeap);

  if (!(iType == BASE_ITEM_LONGBOW ||iType == BASE_ITEM_SHORTBOW )) return;

  if ( GetHasSpellEffect(SPELL_EXTRASHOT,oPC))
          RemoveSpellEffects(SPELL_EXTRASHOT,oPC,oPC);
}


void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bBowSpec=GetHasFeat(FEAT_BOWSPEC2, oPC) ? 2 : 0;
        bBowSpec=GetHasFeat(FEAT_BOWSPEC3, oPC) ? 3 : bBowSpec;
        bBowSpec=GetHasFeat(FEAT_BOWSPEC4, oPC) ? 4 : bBowSpec;
        bBowSpec=GetHasFeat(FEAT_BOWSPEC5, oPC) ? 5 : bBowSpec;
        bBowSpec=GetHasFeat(FEAT_BOWSPEC6, oPC) ? 6 : bBowSpec;
        bBowSpec=GetHasFeat(FEAT_BOWSPEC7, oPC) ? 7 : bBowSpec;
        bBowSpec=GetHasFeat(FEAT_BOWSPEC8, oPC) ? 8 : bBowSpec;
        bBowSpec=GetHasFeat(FEAT_BOWSPEC9, oPC) ? 9 : bBowSpec;

    int bXShot=GetHasFeat(FEAT_EXTRASHOT, oPC) ? 1 : 0;

    int iEquip = GetLocalInt(oPC,"ONEQUIP");

    SetCompositeAttackBonus(oPC, "ArcherBowSpec", 0);

    if (iEquip !=1) Equip(oPC,bBowSpec,oSkin,bXShot);
    if (iEquip ==1) UnEquip(oPC,bBowSpec,oSkin,bXShot);

}
