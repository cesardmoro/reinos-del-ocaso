//::///////////////////////////////////////////////
//:: Wall of Fire: On Enter
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
ActionDoCommand(SetAllAoEInts(SPELL_GREAT_WALL_OF_DISPEL,OBJECT_SELF, GetSpellSaveDC(),GetHasFeat(FEAT_SHADOWWEAVE,GetAreaOfEffectCreator()) ));

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget;
    
    //Declare and assign personal impact visual effect.
    effect   eVis         = EffectVisualEffect( VFX_IMP_BREACH );
    effect   eImpact      = EffectVisualEffect( VFX_FNF_DISPEL_GREATER );

    int nCasterLevel = AoECasterLevel(OBJECT_SELF);
    int iTypeDispel = GetLocalInt(GetModule(),"BIODispel");

    if(nCasterLevel >20 )
    {
        nCasterLevel = 20;
    }

    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
      
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
            if (iTypeDispel)
                     spellsDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
                  else
                     spellsDispelMagicMod(oTarget, nCasterLevel, eVis, eImpact);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
