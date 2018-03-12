#include "inc_utility"
#include "prc_class_const"

void Lore(object oPC ,object oSkin ,int iLevel)
{

   if(GetLocalInt(oSkin, "MagicalAptitudeSpellcraft") == iLevel) return;

    SetCompositeBonus(oSkin, "MagicalAptitudeSpellcraft", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_SPELLCRAFT);
    SetCompositeBonus(oSkin, "MagicalAptitudeUMD", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_USE_MAGIC_DEVICE);
}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    Lore(oPC, oSkin, 2);
}
