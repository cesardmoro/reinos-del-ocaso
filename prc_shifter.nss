//::///////////////////////////////////////////////
//:: Name        Shifter evaluation
//:: FileName    prc_shifter.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// Fills in some default critters from the shifterlist.2da file

// Called by the EvalPRC function

#include "pnp_shft_main"

void main()
{
    // being called by EvalPRCFeats
    object oPC = OBJECT_SELF;

    int nShifterLevel = GetLevelByClass(CLASS_TYPE_PNP_SHIFTER,oPC);

    object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
    if (!GetLocalInt(oPC,"SHIFTOnEnterHit") || !GetIsObjectValid(oHidePC))
    {

        // If we are entering a module, we have been stripped of the skin
        // and our powers are gone, shift back to true form so we dont confuse the player
        if ( (GetTrueForm(oPC) != GetAppearanceType(oPC)) && !(GetLocalInt(oHidePC,"nPCShifted")) )
        {
		// added a check to see if the player is under a polymorph effect. if they are dont unshift
		// if this script was not run when the player entered the server they may not get it until
		// they try to use polymorph. if they do they would be auto unpolymorphed.
		effect eEff = GetFirstEffect(oPC);
		int iNoGo = FALSE;
		while (GetIsEffectValid(eEff))
		{
			int eType = GetEffectType(eEff);
			if (eType == EFFECT_TYPE_POLYMORPH)
			{
				iNoGo = TRUE;
			}
			eEff = GetNextEffect(oPC);
		}
		if (!iNoGo)
			SetShiftTrueForm(oPC);

        }
	// Set a local on the pc so we dont have to do this more than once
	SetLocalInt(oPC,"SHIFTOnEnterHit",1);
    }

    // Make sure we are not doing this io intesive loop more than once per level
    if (nShifterLevel <= GetLocalInt(oPC,"ShifterDefaultListLevel"))
	return;

    string sShifterFile = "shifterlist";
    string sCreatureResRef = "";
    string sCreatureName = "";
    string sShifterLevel = "0";
    int i = 0;
    int nShiftLevelFile = 0;

    while(sShifterLevel != "")
    {
        sShifterLevel = Get2DAString(sShifterFile,"SLEVEL",i);
        nShiftLevelFile = StringToInt(sShifterLevel);
        if ((nShiftLevelFile <= nShifterLevel) && (sShifterLevel != ""))
        {
		// The creature is a standard that we apply to the shifters spark of life list
		sCreatureResRef = Get2DAString(sShifterFile,"CResRef",i);
	        sCreatureName = Get2DAString(sShifterFile,"CreatureName",i);
	        RecognizeCreature( oPC, sCreatureResRef, sCreatureName);
        }
	i++;
    }

    // Set a local on the PC so we dont do this more than once per level
    SetLocalInt(oPC,"ShifterDefaultListLevel",nShifterLevel);

    return;
}
