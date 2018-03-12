/*:://////////////////////////////////////////////
//:: Name AOE Include
//:: FileName PHS_INC_AOE
//:://////////////////////////////////////////////
//:: Notes
//:://////////////////////////////////////////////
    This is just a set of AOE include functions, used in many AOE's.

    Special:

    - Effects apply On Enter are not added each time a new one is entered, and
      do not stack (why would you get more consealment just because of more gas
      if the original has a lot of gas?)

    - Generic On Enter, and On Exit functions are used to apply the effects,
      and remove them once the exit ALL AOE's

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_REMOVE"
#include "PHS_INC_CONSTANT"

// Assigns a debug string to the Area of Effect Creator
void PHS_AssignAOEDebugString(string sString);
// Mobile AOE check.
// * If the AOE is moving, then the caster get the spell removed.
// * Use On Enter - with a 0.1 second delay.
void PHS_MobileAOECheck(object oCaster, int nSpellID, vector vBefore, object oAreaBefore);

// This will add counter set to iSpellID, on oTarget, and if they have not got
// any effects from the spell already, apply eLink to the target
void PHS_AOE_OnEnterEffects(effect eLink);
// This will take 1 off oTarget's "AOe's of GetSpellId()'s we are affected with".
// - At 0, it will remove all of GetSpellId()'s effects.
// - If not got any of GetSpellId()'s effects, deletes the local
void PHS_AOE_OnExitEffects();

//Assigns a debug string to the Area of Effect Creator
void PHS_AssignAOEDebugString(string sString)
{
    object oTarget = GetAreaOfEffectCreator();
    AssignCommand(oTarget, SpeakString(sString));
}

// Mobile AOE check.
// * If the AOE is moving, then the caster get the spell removed.
// * Use On Enter.
void PHS_MobileAOECheck(object oCaster, int nSpellID, vector vBefore, object oAreaBefore)
{
    // If now the caster has changed its location, or area, it means he was moving (as
    // this is delayed by 0.1 seconds)
    if(GetArea(oCaster) != oAreaBefore ||
       vBefore != GetPosition(oCaster) ||
       GetCurrentAction(oCaster) == ACTION_MOVETOPOINT)
    {
        SendMessageToPC(oCaster, "You are moving, and cannot force a barrier onto someone, so it collapses");
        PHS_RemoveSpellEffectsFromTarget(nSpellID, oCaster);
    }
}

// This will add counter set to iSpellID, on oTarget, and if they have not got
// any effects from the spell already, apply eLink to the target
void PHS_AOE_OnEnterEffects(effect eLink)
{
    object oTarget = GetEnteringObject();
    int nSpellID = GetSpellId();
    // If they already have this spell's effects, we just up the local integer
    string sID = PHS_SPELL_AOE_AMOUNT + IntToString(nSpellID);
    // Original amount of spells we are affected with.
    int iOriginal = GetLocalInt(oTarget, sID);

    // Increase by 1
    int iNew = iOriginal + 1;

    // If not got it, apply new effects
    if(!GetHasSpellEffect(nSpellID, oTarget))
    {
        //Linked effects - removed OnExit.
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
    }
}

// This will take 1 off oTarget's "AOe's of iSpellID's we are affected with".
// - At 0, it will remove all of iSpellID's effects.
// - If not got any of iSpellID's effects, deletes the local
void PHS_AOE_OnExitEffects()
{
    object oTarget = GetExitingObject();
    int iSpellID = GetSpellId();
    // We decrease the local integer set on oTarget by 1, IE, they have exited
    // or got out of 1 AOE.
    string sID = PHS_SPELL_AOE_AMOUNT + IntToString(iSpellID);
    int iOriginal = GetLocalInt(oTarget, sID);

    // Take one
    int iNew = iOriginal - 1;

    // If not got it, delete the local and stop
    if(!GetHasSpellEffect(iSpellID, oTarget))
    {
        DeleteLocalInt(oTarget, sID);
        return;
    }
    else if(iNew > 0)
    {
        // If iOriginal is over 0, we set the new amount left, but remove
        // no effects
        SetLocalInt(oTarget, sID, iNew);
    }
    else //if(iNew <= 0)
    {
        // At 0, delete local.
        DeleteLocalInt(oTarget, sID);

        // Else, we remove th effects of the spell, as they are in no more AOE's

        // Search through the valid effects on the target.
        effect eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            //If the effect was created by the Acid_Fog then remove it
            if(GetEffectSpellId(eAOE) == iSpellID)
            {
                // Remove all effects from Acid Fog
                RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
}
