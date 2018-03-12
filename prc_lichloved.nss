//
// Lichloved By Zedium
//

#include "inc_item_props"
#include "prc_feat_const"

///Lich Loved +1 on saves vs. Mind Affecting, Poison, and Disease /////////
void Lich_Loved(object oPC, object oSkin)
{
   if(GetLocalInt(oSkin, "LichLovedD") == 1) return;

    SetCompositeBonus(oSkin, "LichLovedM", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEVS_MINDAFFECTING);
    SetCompositeBonus(oSkin, "LichLovedP", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEVS_POISON);
    SetCompositeBonus(oSkin, "LichLovedD", 1, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC,IP_CONST_SAVEVS_DISEASE);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
  
   if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
   {
   	Lich_Loved(oPC, oSkin);
   }
}