#include "prc_feat_const"
#include "prc_spell_const"
//#include "NW_I0_GENERIC"
#include "nw_i0_spells"
//#include "inc_utility"
#include "inc_item_props"

void main()
{
  object oTarget = OBJECT_SELF;

  if (GetHasFeatEffect(FEAT_SONG_OF_FURY,OBJECT_SELF))
   {
     RemoveSpellEffects(SPELL_SONG_OF_FURY,oTarget,oTarget);
     return;
   }


  object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
  object oWeapL=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);
  object oWeapR=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
  //object oHide=GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

  if  (GetBaseAC(oArmor)>4)return;

  if (
       (GetIsObjectValid(oWeapL) && GetIsObjectValid(oWeapR) ) ||
       (!GetIsObjectValid(oWeapL) && !GetIsObjectValid(oWeapR) )
     )
        return;


   // only rapier or longsword
  if (  !(GetBaseItemType(oWeapL)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapR)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapL)==BASE_ITEM_LONGSWORD ||
          GetBaseItemType(oWeapR)==BASE_ITEM_LONGSWORD) )

        return;

   effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);
   effect eLink=EffectLinkEffects(EffectAttackDecrease(2),EffectModifyAttacks(1));
          eLink=EffectLinkEffects (eLink,eVis);

   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eLink), oTarget);
}

