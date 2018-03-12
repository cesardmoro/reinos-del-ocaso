/*:://////////////////////////////////////////////
//:: Spell Name Dancing Lights - Heartbeat
//:: Spell FileName PHS_S_DanclightC
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Moves them to a cirtain place depending on their tag.

    Basically, 1 is north, 2 east, 3 south, 4 west.

    Moves there. If caster gets out of 20M away, it winks out.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

const string PHS_DANCING_LIGHT_SET  = "PHS_DANCING_LIGHT_SET";

// Destroy self.
void DestroySelf();

void main()
{
    // Check if caster is valid and in range
    object oCaster = GetLocalObject(OBJECT_SELF, PHS_DANCING_LIGHT_SET);
    // Check if valid & in 20M & still got spell effects
    if(!GetIsObjectValid(oCaster) || GetDistanceToObject(oCaster) > 20.0 ||
       !GetHasSpellEffect(PHS_SPELL_DANCING_LIGHTS, oCaster))
    {
        DestroySelf();
        return;
    }
    // Set up us if not already
    if(!GetLocalInt(OBJECT_SELF, "DO_ONCE"))
    {
        SetLocalInt(OBJECT_SELF, "DO_ONCE", TRUE);
        // Ghost effect
        effect eGhost = SupernaturalEffect(EffectCutsceneGhost());
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eGhost, OBJECT_SELF);
    }

    // If valid and so forth, move to respective position
    int iNumber = GetLocalInt(OBJECT_SELF, PHS_DANCING_LIGHT_SET);

    vector vCaster = GetPosition(oCaster);
    float fNewX;
    float fNewY;
    // Check iNumber
    if(iNumber == FALSE)
    {
        DestroySelf();
        return;
    }
    // Move to position 1 = north
    else if(iNumber == 1)
    {
        // +1.5 in Y  /\
        fNewX = vCaster.x;
        fNewY = vCaster.y + 1.5;
    }
    // 2 = east
    else if(iNumber == 2)
    {
        // +1.5 in X  ->
        fNewX = vCaster.x + 1.5;
        fNewY = vCaster.y;
    }
    // 3 = south
    else if(iNumber == 3)
    {
        // -1.5 in Y  \/
        fNewX = vCaster.x;
        fNewY = vCaster.y - 1.5;
    }
    // 4 = west
    else if(iNumber == 4)
    {
        // -1.5 in X  <-
        fNewX = vCaster.x - 1.5;
        fNewY = vCaster.y;
    }
    else // Invalid if over 4
    {
        DestroySelf();
        return;
    }
    vector vTotal = Vector(fNewX, fNewY, vCaster.z);
    // Finalise location
    location lMove = Location(GetArea(oCaster), vTotal, 0.0);

    // Move to location
    ClearAllActions();
    ActionMoveToLocation(lMove, TRUE);
}

// Destroy self.
void DestroySelf()
{
    SetImmortal(OBJECT_SELF, FALSE);
    SetPlotFlag(OBJECT_SELF, FALSE);
    DestroyObject(OBJECT_SELF);
}
