//::///////////////////////////////////////////////
//:: Turns player into a werewolf
//:: prc_wwhybridwolf
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 11, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_inc_clsfunc"

void main()
{
    object oPC = OBJECT_SELF;
    int nPoly;

	

   if (GetLocalInt(oPC, "WWHybrid") != TRUE)
   {
    	//Can only turn into a werewolf if level 2 in werewolf class
    	if (!GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2))
    	{
    	    FloatingTextStringOnCreature("You can only assume your hybrid form if you are at least level 2 in the werewolf class", oPC, FALSE);
    	    return;
    	}
	
    	nPoly = POLYMORPH_TYPE_WEREWOLF_0s;
	
    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1))
    	{
    	    nPoly = POLYMORPH_TYPE_WEREWOLF_1s;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2))
    	{
    	    nPoly = POLYMORPH_TYPE_WEREWOLF_2s;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
    	{
    	    nPoly = POLYMORPH_TYPE_WEREWOLF_0l;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1)  && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
    	{
    	    nPoly = POLYMORPH_TYPE_WEREWOLF_1l;
    	}
    	if (GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2)  && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
    	{
    	    nPoly = POLYMORPH_TYPE_WEREWOLF_2l;
    	}

	LycanthropePoly(oPC, nPoly);
    	SetLocalInt(oPC, "WWHybrid", TRUE);
    
    }
    else
    {
    ExecuteScript("prc_wwunpoly", oPC);
    SetLocalInt(oPC, "WWHybrid", FALSE);
    }
}


