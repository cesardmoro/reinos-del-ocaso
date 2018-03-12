//::///////////////////////////////////////////////
//:: [Ressurection]
//:: [NW_S0_Ressurec.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Brings a character back to life with full
//:: health.
//:: When cast on placeables, you get a default error message.
//::   * You can specify a different message in
//::      X2_L_RESURRECT_SPELL_MSG_RESREF
//::   * You can turn off the message by setting the variable
//::     to -1
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Z on 2003-07-31
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "x2_inc_spellhook"
//#include "traermuerto"
#include "sp_resu_inc"

const int RESURRECTION_GOLD_COST = 500;

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

    if(GetGold() >= RESURRECTION_GOLD_COST || GetIsPC(OBJECT_SELF) == FALSE)
    {
        object oTarget = GetSpellTargetObject();
        ResurrectCreature( oTarget, RESURRECTION_GOLD_COST, Muerte_REVIVIDO_CON_RESURRECTION );
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESURRECTION, FALSE));
    }
}

