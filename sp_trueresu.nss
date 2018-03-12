//::///////////////////////////////////////////////
//:: [True Ressurection]
//:: [sp_trueresu.nss]
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
//:: Created By: dragoncin
//:: Created On: Aug 06, 2007
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "sp_resu_inc"
#include "rdo_spell_const"

const int RESURRECTION_GOLD_COST = 2400;

void main()
{

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    if(GetGold() >= RESURRECTION_GOLD_COST || GetIsPC(OBJECT_SELF) == FALSE || GetIsDM(OBJECT_SELF) == TRUE || GetIsDMPossessed(OBJECT_SELF) == TRUE)
    {
        object oTarget = GetSpellTargetObject();
        if (GetIsObjectValid(oTarget))
        {
            ResurrectCreature( oTarget, RESURRECTION_GOLD_COST, Muerte_REVIVIDO_CON_TRUERESURRECTION );
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_TRUE_RESURRECTION, FALSE));
        }
        else
        {
            SetLocalLocation(OBJECT_SELF, TrueResurrection_targetLocation_VN, GetSpellTargetLocation());
            ActionStartConversation(OBJECT_SELF, "true_resurrectio", TRUE, FALSE);
        }
    }
}

