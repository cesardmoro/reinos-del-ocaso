#include "nw_i0_spells"
#include "prc_inc_unarmed"
#include "prc_inc_clsfunc"

void SacredAC(object oPC,object oSkin,int bSFAC ,int iShield)
{
   object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);

   if  (GetBaseAC(oArmor)>3 || iShield)
      SetCompositeBonus(oSkin, "SacFisAC", 0, ITEM_PROPERTY_AC_BONUS);
   else
      SetCompositeBonus(oSkin, "SacFisAC", bSFAC, ITEM_PROPERTY_AC_BONUS);


}

void SacredSpeed(object oPC,object oSkin,int bSFSpeed ,int iShield)
{
   object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);

   if (GetBaseAC(oArmor) > 3 || iShield )
   {
       RemoveEffectsFromSpell(oPC,SPELL_SACREDSPEED);
   }
   else 
   {
       ActionCastSpellOnSelf(SPELL_SACREDSPEED);
   }

}

void main()
{
  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    
    RemoveEffectsFromSpell(oPC, SPELL_SACREDSPEED);

    int iClass = GetLevelByClass(CLASS_TYPE_SACREDFIST,oPC);

    int bSFAC=GetHasFeat(FEAT_SF_AC1, oPC) ? 1 : 0;
        bSFAC=GetHasFeat(FEAT_SF_AC2, oPC) ? 2 : bSFAC;
        bSFAC=GetHasFeat(FEAT_SF_AC3, oPC) ? 3 : bSFAC;
        bSFAC=GetHasFeat(FEAT_SF_AC4, oPC) ? 4 : bSFAC;
        bSFAC=GetHasFeat(FEAT_SF_AC5, oPC) ? 5 : bSFAC;
        bSFAC=GetHasFeat(FEAT_SF_AC6, oPC) ? 6 : bSFAC;
        bSFAC=GetHasFeat(FEAT_SF_AC7, oPC) ? 7 : bSFAC;


    int bSFSpeed=GetHasFeat(FEAT_SF_SPEED1, oPC) ? 1 : 0;
        bSFSpeed=GetHasFeat(FEAT_SF_SPEED2, oPC) ? 2 : bSFSpeed;
        bSFSpeed=GetHasFeat(FEAT_SF_SPEED3, oPC) ? 3 : bSFSpeed;

    object oItemR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oItemL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

 //   int bSFAC = iClass/5 +1;

    int iCode =  GetHasFeat(FEAT_SF_CODE);

    int iShield = GetBaseItemType(oItemL)== BASE_ITEM_TOWERSHIELD || GetBaseItemType(oItemL)== BASE_ITEM_LARGESHIELD || GetBaseItemType(oItemL)== BASE_ITEM_SMALLSHIELD ;

    if (!iCode)
    {
       if ( oItemR ==   OBJECT_INVALID)
       {
         if ( oItemL ==   OBJECT_INVALID || GetBaseItemType(oItemL)==BASE_ITEM_TORCH || iShield)
         {}
         else
         {
          if (!GetHasFeat(FEAT_SF_CODE,oPC))
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SF_CODE),oSkin);
          iCode = 1;
          FloatingTextStringOnCreature("You lost all your Sacred Fist powers.", OBJECT_SELF, FALSE);

         }
       }
       else
       {
          if (!GetHasFeat(FEAT_SF_CODE,oPC))
           AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SF_CODE),oSkin);
          iCode = 1;
          FloatingTextStringOnCreature("You lost all your Sacred Fist powers.", OBJECT_SELF, FALSE);


       }
    }

    if (iCode)
    {
       bSFAC = 0;
       bSFSpeed=0;
       SetCompositeBonus(oSkin, "SacFisAC", 0, ITEM_PROPERTY_AC_BONUS);
       if (GetHasSpellEffect(SPELL_SACREDSPEED,oPC))
          RemoveSpellEffects(SPELL_SACREDSPEED,oPC,oPC);
       if (GetHasSpellEffect(SPELL_SACREDFLAME,oPC))
          RemoveSpellEffects(SPELL_SACREDFLAME,oPC,oPC);
       if (GetHasSpellEffect(SPELL_INNERARMOR,oPC))
          RemoveSpellEffects(SPELL_INNERARMOR,oPC,oPC);
       DeleteLocalInt(oSkin,"SacFisMv");
       while(GetHasFeat(FEAT_SF_SACREDFLAME1))
       DecrementRemainingFeatUses(oPC,FEAT_SF_SACREDFLAME1);

       while(GetHasFeat(FEAT_SF_INNERARMOR))
         DecrementRemainingFeatUses(oPC,FEAT_SF_INNERARMOR);

    }

    if (bSFAC>0 && !iCode)    SacredAC(oPC,oSkin,bSFAC,iShield);
    if (bSFSpeed>0 && !iCode) SacredSpeed(oPC,oSkin,bSFSpeed,iShield);

    //Evaluate The Unarmed Strike Feats
    UnarmedFeats(oPC);

    //Evaluate Fists
    UnarmedFists(oPC);


}