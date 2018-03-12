//::///////////////////////////////////////////////
//:: [Raise Dead]
//:: [NW_S0_RaisDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Brings a character back to life with 1 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "x2_inc_spellhook"
//#include "traermuerto"
#include "sp_resu_inc"

const int RAISE_DEAD_GOLD_COST = 100;

void main()
{

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

    if(GetGold() >= RAISE_DEAD_GOLD_COST || GetIsPC(OBJECT_SELF) == FALSE)
    {
        object oTarget = GetSpellTargetObject();
        ResurrectCreature( oTarget, RAISE_DEAD_GOLD_COST, Muerte_REVIVIDO_CON_RAISE_DEAD );
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAISE_DEAD, FALSE));
    }
}

