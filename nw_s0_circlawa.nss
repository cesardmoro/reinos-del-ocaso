//::///////////////////////////////////////////////
//:: Magic Cirle Against Evil
//:: NW_S0_CircEvilA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from evil effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "prc_alterations"

#include "x2_inc_spellhook"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_MAGIC_CIRCLE_AGAINST_LAW,OBJECT_SELF, GetSpellSaveDC()));


    object oTarget = GetEnteringObject();
    if(GetIsFriend(oTarget, GetAreaOfEffectCreator()))
    {
        //Declare major variables
        int nDuration = PRCGetCasterLevel(OBJECT_SELF);
        //effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
        effect eLink = CreateProtectionFromAlignmentLink2(ALIGNMENT_LAWFUL);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_CIRCLE_AGAINST_LAW, FALSE));

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,FALSE);
     }
}
