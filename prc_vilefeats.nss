#include "inc_item_props"
#include "prc_feat_const"

////    Deformity (Obese)    ////
void DeformObese(object oPC ,object oSkin)
{

  if(GetLocalInt(oSkin, "DeformObeseCon") == 2) return;

    SetCompositeBonus(oSkin, "DeformObeseCon", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_CON);
    SetCompositeBonus(oSkin, "DeformObeseDex", 2, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_DEX);
    SetCompositeBonus(oSkin, "DeformObeseIntim", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
    SetCompositeBonus(oSkin, "DeformObesePoison", 2, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, IP_CONST_SAVEVS_POISON);
}

////    Deformity (Gaunt)    ////
void DeformGaunt(object oPC ,object oSkin)
{

  if(GetLocalInt(oSkin, "DeformGauntDex") == 2) return;

    SetCompositeBonus(oSkin, "DeformGauntDex", 2, ITEM_PROPERTY_ABILITY_BONUS,IP_CONST_ABILITY_DEX);
    SetCompositeBonus(oSkin, "DeformGauntCon", 2, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CON);
    SetCompositeBonus(oSkin, "DeformGauntIntim", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
    SetCompositeBonus(oSkin, "DeformGauntHide", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_HIDE);
    SetCompositeBonus(oSkin, "DeformGauntMS", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_MOVE_SILENTLY);
}

////    Willing Deformity    ////
void WillDeform(object oPC ,object oSkin)
{

  if(GetLocalInt(oSkin, "WillDeform") == 2) return;

    SetCompositeBonus(oSkin, "WillDeform", 2, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);
}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    if ( GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC)  &&  !GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC) && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)   DeformObese(oPC, oSkin);
    if ( GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC)  &&  !GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC) && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)   DeformGaunt(oPC, oSkin);
    if ( GetHasFeat(FEAT_VILE_WILL_DEFORM, oPC) && GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)   WillDeform(oPC, oSkin);
}
