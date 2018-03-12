//::///////////////////////////////////////////////
//:: Magic Cirle Against Good
//:: NW_S0_CircGoodA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from good effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"
#include "prc_inc_clsfunc"
#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

 
    ActionDoCommand(SetAllAoEInts(SPELL_MAGIC_CIRCLE_AGAINST_GOOD ,OBJECT_SELF, GetSpellSaveDC(),0,GetLevelByClass(CLASS_TYPE_ANTI_PALADIN,GetAreaOfEffectCreator())/2));


    object oTarget = GetEnteringObject();
    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
        //Declare major variables
        //effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
        effect eLink = CreateProtectionFromAlignmentLink(ALIGNMENT_GOOD);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_GOOD, FALSE));

        //Apply the VFX impact and effects
        //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE);
     }
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
