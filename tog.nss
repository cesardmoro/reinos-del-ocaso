
#include "prc_class_const"
#include "inc_utility"
#include "prc_feat_const"

// Bonus on certain CHA based skills
void Dark_Charisma(object oPC ,object oSkin, int nLevel)
{
    int nBonus = 0;    
    if(nLevel >= 3)  nBonus++;
    if(nLevel >= 5)  nBonus++;
    if(nLevel >= 7)  nBonus++;
    if(nLevel >= 11) nBonus++;
    if(nLevel >= 13) nBonus++;
    if(nLevel >= 17) nBonus++;
    if(nLevel >= 21) nBonus++;
    if(nLevel >= 25) nBonus++;
    if(nLevel >= 29) nBonus++;
    
    // string sMes = "Dark Charm Bonus: " + IntToString(nBonus);
    // FloatingTextStringOnCreature(sMes, oPC);
    
    if(GetLocalInt(oSkin, "Dark_Charm_AE") == nBonus) return;

    SetCompositeBonus(oSkin, "Dark_Charm_AE", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_ANIMAL_EMPATHY);
    SetCompositeBonus(oSkin, "Dark_Charm_PF", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERFORM);
    SetCompositeBonus(oSkin, "Dark_Charm_PS", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "Dark_Charm_BL", nBonus, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
}

void main()
{
    // Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nLevel = GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, OBJECT_SELF) + GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D, OBJECT_SELF);
       
    Dark_Charisma(oPC, oSkin, nLevel);
}