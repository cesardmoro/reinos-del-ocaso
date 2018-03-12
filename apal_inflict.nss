//::///////////////////////////////////////////////
//:: [Inflict Wounds]
//:: [X0_S0_Inflict.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: This script is used by all the inflict spells
//::
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_alterations"
#include "prc_inc_clsfunc"

#include "X0_I0_SPELLS" // * this is the new spells include for expansion packs

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    int CasterLvl = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN)/2;
    if (GetLocalInt(OBJECT_SELF, "Apal_DeathKnell") == TRUE)
    {
        CasterLvl = CasterLvl + 1;
    }    
    
    int nSpellID = GetSpellId();
    switch (nSpellID)
    {
/*Light*/     case SPELL_ANTIPAL_INFLICT_LIGHT_WOUNDS: 
                 if (!CanCastSpell(1)) return;
                 spellsInflictTouchAttack(d8(), 5, 8, 246, VFX_IMP_HEALING_G, nSpellID,CasterLvl,GetSpellDCSLA(OBJECT_SELF,1)); break;
/*Moderate*/   case SPELL_ANTIPAL_INFLICT_MODERATE_WOUNDS:
                 if (!CanCastSpell(3)) return;
                 spellsInflictTouchAttack(d8(2), 10, 16, 246, VFX_IMP_HEALING_G, nSpellID,CasterLvl,GetSpellDCSLA(OBJECT_SELF,3)); break;
/*Serious*/    case SPELL_ANTIPAL_INFLICT_SERIOUS_WOUNDS: 
                 if (!CanCastSpell(4)) return;
                 spellsInflictTouchAttack(d8(3), 15, 24, 246, VFX_IMP_HEALING_G, nSpellID,CasterLvl,GetSpellDCSLA(OBJECT_SELF,4)); break;

    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
