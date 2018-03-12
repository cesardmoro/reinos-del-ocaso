/* Combat medic
 *
 * Created July 17 2005
 * Author: GaiaWerewolf
 */

#include "inc_utility"
#include "prc_class_const"

void ConcentrationBonus(object oPC, object oSkin, int iLevel)
{
   if(GetLocalInt(oSkin, "CbtMed_Concentration") == iLevel) return;

    SetCompositeBonus(oSkin, "CbtMed_Concentration", iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_CONCENTRATION);
}

void HealBonus(object oPC, object oSkin, int iLevel)
{
   if(GetLocalInt(oSkin, "CbtMed_Heal") == iLevel) return;

    SetCompositeBonus(oSkin, "CbtMed_Heal", iLevel, ITEM_PROPERTY_SKILL_BONUS, SKILL_HEAL);
}

void main()
{
     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_COMBAT_MEDIC, oPC);
    ConcentrationBonus(oPC, oSkin, nClass);
    HealBonus(oPC, oSkin, nClass);
}
