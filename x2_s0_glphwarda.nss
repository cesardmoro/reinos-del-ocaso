//::///////////////////////////////////////////////
//:: Glyph of Warding: On Enter
//:: X2_S0_GlphWardA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This script creates a Glyph of Warding Placeable
    object.

    Check x2_o0_hhb.nss and the Glyph of Warding
    placeable object for details
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"


#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
ActionDoCommand(SetAllAoEInts(SPELL_GLYPH_OF_WARDING,OBJECT_SELF, GetSpellSaveDC()));

    object oTarget  = GetEnteringObject();
    object oPLC     = GetAreaOfEffectCreator(OBJECT_SELF);
    object oCreator = GetLocalObject(oPLC,"X2_PLC_GLYPH_CASTER") ;

    if ( GetLocalInt (oPLC,"X2_PLC_GLYPH_PLAYERCREATED") == 0 )
    {
        oCreator = oPLC;
    }

    if (!GetIsObjectValid(oPLC) || !GetIsObjectValid(oCreator)) // the placeable or creator is no longer there
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,oCreator))
    {
        SetLocalObject(oPLC,"X2_GLYPH_LAST_ENTER",oTarget );
        SignalEvent(oPLC,EventUserDefined(2000));
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}
