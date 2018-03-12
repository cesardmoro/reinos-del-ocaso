#include "inc_item_props"
#include "prc_class_const"

void SwayingWaist(object oPC, object oSkin, int iLevel)
{
    if(GetLocalInt(oSkin, "DMWaist") == iLevel) return;

    SetCompositeBonus(oSkin, "AcolyteSkinBonus", iLevel, ITEM_PROPERTY_AC_BONUS);
}

void main ()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iAC;

    if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) >= 3)     {     iAC = 2;     }     else if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) >= 4)     {     iAC = 3;     }     else if(GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC) >= 9)     {     iAC = 4;     }

SwayingWaist(oPC, oSkin, iAC);
}