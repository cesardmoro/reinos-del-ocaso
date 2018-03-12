/*:://////////////////////////////////////////////
//:: Spell Name Imprisonment
//:: Spell FileName PHS_S_Imprison
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Touched attack, will negates. They are put into suspended animation, somewhere
    under the earth. Freedom releases. -4 on save if they are in the same party.
    SR applies.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Save VS will, or get sent to a place like maze! :-)

    Easy to do, and uses some of mazes things.

    No getting out, however. This can be like death to a PC, so we pop up a
    dialog box for death like Petrify.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_IMPRISONMENT)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oTargetArea = GetArea(oTarget);
    // - Use oTarget location in case GetSpellTargetLocatoin() isn't equal to it.
    location lTarget = GetLocation(oTarget);
    object oNewPrisonObject;
    object oPrisonPoint = GetWaypointByTag(PHS_S_IMPRISONMENT_TARGET);
    // We use JumpToLocation, a random point away from oPrison Point so creatures
    // put in prison are not all together.
    // - Up to 20M in all directions.
    location lPrisonPoint = PHS_GetRandomLocation(GetLocation(oPrisonPoint), 40);

    // Melee touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

    // DC
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    // +4 DC if equal faction
    if(GetFactionEqual(oTarget))
    {
        nSpellSaveDC += 4;
    }

    // Delcare impact effect
    effect eVis = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    effect eVis2 = EffectVisualEffect(785);
    // A duration effect, just so it is something to check.
    effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);

    // Always fire spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_IMPRISONMENT, TRUE);

    // No beam hit/miss visual - basically, the new VFX looks better.

    // Melee Touch Attack
    if(nTouch)
    {
        // - It is a minotaur?
        // - Can it be destroyed?
        if(PHS_CanCreatureBeDestroyed(oTarget) &&
           GetIsObjectValid(oPrisonPoint) &&
          !PHS_IsInMazeArea(oTarget) &&
          !PHS_IsInPrisonArea(oTarget))
        {
            // Spell Resistance only Check
            if(!PHS_SpellResistanceOnlyCheck(oCaster, oTarget))
            {
                // Will save
                if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC))
                {
                    // Apply instant visuals to the location and target.
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, lTarget);

                    // Apply a duration effect
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDur, oTarget);

                    // Set variables to jump back to.
                    SetLocalLocation(oTarget, PHS_S_MAZEPRISON_LOCATION, lTarget);
                    SetLocalObject(oTarget, PHS_S_MAZEPRISON_OLD_AREA, oTargetArea); // A check for LOCATION is valid.

                    // Create Imprisonment object, and set local object to the target
                    oNewPrisonObject = CreateObject(OBJECT_TYPE_PLACEABLE, PHS_IMPRISONMENT_OBJECT, lTarget);
                    // Set local object so freedom works.
                    SetLocalObject(oNewPrisonObject, PHS_MAZEPRISON_OBJECT, oTarget);
                    // Set local object on the PC so they know which is thiers
                    // - Same variable name.
                    SetLocalObject(oTarget, PHS_MAZEPRISON_OBJECT, oNewPrisonObject);

                    // Move there and commandable.
                    AssignCommand(oTarget, ClearAllActions());
                    AssignCommand(oTarget, JumpToLocation(lPrisonPoint));

                    // Set plot flag on enter, and are set to uncommandable.
                }
            }
        }
    }
}
