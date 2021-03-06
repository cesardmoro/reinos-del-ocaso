//::///////////////////////////////////////////////
//:: Contagion
//:: NW_S0_Contagion.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The target must save or be struck down with
    Blidning Sickness, Cackle Fever, Filth Fever
    Mind Fire, Red Ache, the Shakes or Slimy Doom.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 6, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "prc_alterations"
#include "spinc_common"
#include "x2_inc_spellhook"

void main()
{
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    int CasterLvl = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN);
    if (GetLocalInt(OBJECT_SELF, "Apal_DeathKnell") == TRUE)
    {
        CasterLvl = CasterLvl + 1;
    }

    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nDC = PRCGetSaveDC(oTarget, OBJECT_SELF);
    int nRand = Random(7)+1;
    int nDisease;
    //Use a random seed to determine the disease that will be delivered.
    switch (nRand)
    {
        case 1:
            nDisease = DISEASE_CONTAGION_BLINDING_SICKNESS;
        break;
        case 2:
            nDisease = DISEASE_CONTAGION_CACKLE_FEVER;
        break;
        case 3:
            nDisease = DISEASE_CONTAGION_FILTH_FEVER;
        break;
        case 4:
            nDisease = DISEASE_CONTAGION_MINDFIRE;
        break;
        case 5:
            nDisease = DISEASE_CONTAGION_RED_ACHE;
        break;
        case 6:
            nDisease = DISEASE_CONTAGION_SHAKES;
        break;
        case 7:
            nDisease = DISEASE_CONTAGION_SLIMY_DOOM;
        break;
    }
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTAGION));
        effect eDisease = EffectDisease(nDisease);
        //Make SR check
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget, CasterLvl + SPGetPenetr()))
        {
            // Make the real first save against the spell's DC
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
            {
                //The effect is permament because the disease subsystem has its own internal resolution
                //system in place.
                // The first disease save is against an impossible fake DC, since at this point the
                // target has already failed their real first save.
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget, 0.0f, TRUE, -1, CasterLvl);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

