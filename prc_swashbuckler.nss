#include "prc_alterations"
#include "prc_feat_const"
#include "prc_inc_clsfunc"
#include "rdo_spinc"
#include "Item_inc"
#include "x2_inc_itemprop"

//DAMAGE_TYPE_BASE_WEAPON
//GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)

//Add INT bonus to damage inflicted, when they are in light armor or less.
//Still need to remove bonus when they are encumbered.
//Need to add an onhit to see if the target is Crit or Sneak immune, and heal the INT bonus back.


//Need to add in Weakening and Wounding criticals (on crit, deal 2 STR and 2 Con, respectively).

//Applies Reflex Save bonus is the character is in light armor or less.
//Still need to remove bonus when they are encumbered.
void Grace(object oPC, object oSkin,int sGrace)
{
   object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
   int iBase = GetBaseAC(oArmor);
   int iMax = 4;

   if  (GetBaseAC(oArmor)>iMax )
     SetCompositeBonus(oSkin,"SwashGrace",0,ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEBASETYPE_REFLEX);
   else
     SetCompositeBonus(oSkin,"SwashGrace",sGrace,ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEBASETYPE_REFLEX);

}

//Applies a Dodge AC boost when they are wearing light armor or less.
//Still need to remove bonus when they are encumbered.
void Dodge(object oPC, object oSkin,int sDodge)
{
   object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
   int iBase = GetBaseAC(oArmor);
   int iMax = 4;

   if  (GetBaseAC(oArmor)>iMax )
     SetCompositeBonus(oSkin,"SwashAC",0,ITEM_PROPERTY_AC_BONUS);
   else
     SetCompositeBonus(oSkin,"SwashAC",sDodge,ITEM_PROPERTY_AC_BONUS);

}

const string Swashbuckler_InsStrike_EFFECT_CREATOR = "Swash_InsStr_CREATOR";

//Adds Int bonus to damage.
//Make a special on-hit that heals your INT bonus if the target is immune to Sneak or Crits
//Make this only apply to weapons useable with weapon finesse
//make this not apply if you are wearing medium or heavy armor, or are encumbered.
void SmartWound(object oPC, object oSkin, int iStrike, int iEquip)
{
    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    int iLight;
    switch (GetBaseItemType(oWeapon)) {
        case BASE_ITEM_DAGGER:          iLight = TRUE; break;
        case BASE_ITEM_HANDAXE:         iLight = TRUE; break;
        case BASE_ITEM_KAMA:            iLight = TRUE; break;
        case BASE_ITEM_KUKRI:           iLight = TRUE; break;
        case BASE_ITEM_LIGHTHAMMER:     iLight = TRUE; break;
        case BASE_ITEM_LIGHTMACE:       iLight = TRUE; break;
        case BASE_ITEM_RAPIER:          iLight = TRUE; break;
        case BASE_ITEM_SHORTSWORD:      iLight = TRUE; break;
        case BASE_ITEM_SICKLE:          iLight = TRUE; break;
        case BASE_ITEM_WHIP:            iLight = TRUE; break;
        default:                        iLight = FALSE; break;
    }

    object oCreator = RDO_GetCreatorByTag(Swashbuckler_InsStrike_EFFECT_CREATOR);
    RDO_RemoveEffectsByCreator(oPC, oCreator);
    if (GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST,oPC)) <= 4 && iLight == TRUE)
        AssignCommand(oCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectDamageIncrease(IPGetDamageBonusConstantFromNumber(GetAbilityModifier(ABILITY_INTELLIGENCE, oPC)), Item_GetWeaponDamageType(oWeapon))), oPC));
}

//This makes a unique on hit which calls on the "prc_swashweak" scripts
//to simulate a critical hit roll percentage.  On success, it deals
//2 STR damage (and 2 CON damage at level 19)
void CritSTR(object oPC, object oSkin,int iStrike, int iEquip)
{
  object oItem ;
  object oItemb ;

  if (iEquip==2)
     {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     if ( GetLocalInt(oItem,"CritHarm")) return;

     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
     SetLocalInt(oItem,"CritHarm",1);
     }
  else if (iEquip==1)
     {
     oItem=GetPCItemLastUnequipped();
     RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0,1,"",-1,DURATION_TYPE_TEMPORARY);
     DeleteLocalInt(oItem,"CritHarm");
     }
  else
     {
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
     if (!GetLocalInt(oItem,"CritHarm"))
        {
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItem,9999.0);
        SetLocalInt(oItem,"CritHarm",1);
        }
     }

  if (iEquip==2)
     {
     oItemb=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     if ( GetLocalInt(oItemb,"CritHarm")) return;

     AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItemb,9999.0);
     SetLocalInt(oItemb,"CritHarm",1);
     }
  else if (iEquip==1)
     {
     oItemb=GetPCItemLastUnequipped();
     RemoveSpecificProperty(oItemb,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,0,1,"",-1,DURATION_TYPE_TEMPORARY);
     DeleteLocalInt(oItemb,"CritHarm");
     }
  else
     {
     oItemb=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     if (!GetLocalInt(oItemb,"CritHarm"))
        {
        AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER,1),oItemb,9999.0);
        SetLocalInt(oItemb,"CritHarm",1);
        }
     }
}

void main()
{
  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iClass = GetLevelByClass(CLASS_TYPE_SWASHBUCKLER,oPC);

    int sGrace = GetHasFeat(FEAT_SWASH_GRACE1, oPC) ? 1 : 0;
        sGrace = GetHasFeat(FEAT_SWASH_GRACE2, oPC) ? 2 : sGrace;
        sGrace = GetHasFeat(FEAT_SWASH_GRACE3, oPC) ? 3 : sGrace;
        sGrace = GetHasFeat(FEAT_SWASH_GRACE4, oPC) ? 4 : sGrace;
        sGrace = GetHasFeat(FEAT_SWASH_GRACE5, oPC) ? 5 : sGrace;

    int sDodge = GetHasFeat(SWASH_DODGE_1, oPC) ? 1 : 0;
        sDodge = GetHasFeat(SWASH_DODGE_2, oPC) ? 2 : sDodge;
        sDodge = GetHasFeat(SWASH_DODGE_3, oPC) ? 3 : sDodge;
        sDodge = GetHasFeat(SWASH_DODGE_4, oPC) ? 4 : sDodge;
        sDodge = GetHasFeat(SWASH_DODGE_5, oPC) ? 5 : sDodge;
        sDodge = GetHasFeat(SWASH_DODGE_6, oPC) ? 6 : sDodge;
        sDodge = GetHasFeat(SWASH_DODGE_7, oPC) ? 7 : sDodge;
        sDodge = GetHasFeat(SWASH_DODGE_8, oPC) ? 8 : sDodge;

    int iStrike = GetHasFeat(INSIGHTFUL_STRIKE, oPC);
    int iEquip= GetLocalInt(oPC,"ONEQUIP");

    int WeakCrit = GetHasFeat(WEAKENING_CRITICAL, oPC);
    int WoundCrit = GetHasFeat(WOUNDING_CRITICAL, oPC);

    if (sGrace>0) Grace(oPC,oSkin,sGrace);
    if (sDodge>0) Dodge(oPC,oSkin,sDodge);
    if (iStrike>0) SmartWound(oPC,oSkin,iStrike,iEquip);
    if (iStrike>0) CritSTR(oPC,oSkin,iStrike,iEquip);
}
