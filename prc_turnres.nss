//::///////////////////////////////////////////////
//:: Name   Turn Resistance
//:: FileName   prc_turnres
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*  Serves as a hub for the calculation of inherent
    turn resistances.
*/
//:://////////////////////////////////////////////
//:: Created By:   Tenjac
//:: Created On:   12/17/04
//:://////////////////////////////////////////////


#include "inc_utility"
#include "prc_class_const"
void main()
{
    //Define variables
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nTurnResist = 0;
    int nAlignGE = GetAlignmentGoodEvil(oPC);
    int nAlignLC = GetAlignmentLawChaos(oPC);
    //Define variables for classes
    int nBaelnLevel = GetLevelByClass(CLASS_TYPE_BAELNORN);

    //Increment turn nTurnRes for class levels when appropriate.

    //Baelnorn Turn Resistance 1 per level, but only when good aligned
    if (nBaelnLevel > 0)
    {
        if (nAlignGE == ALIGNMENT_GOOD)
        {
            nTurnResist += nBaelnLevel;
        }
    }

    //Apply Turn Resistance
    SetCompositeBonus(oSkin, "TurnRes", nTurnResist, ITEM_PROPERTY_TURN_RESISTANCE);
}

