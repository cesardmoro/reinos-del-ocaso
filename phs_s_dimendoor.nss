/*:://////////////////////////////////////////////
//:: Spell Name Dimension Door
//:: Spell FileName PHS_S_DimenDoor
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    Long range. You can teleport you and 1 medium creature/caster level (in 5M)
    to the location.
    For 1 turn, the caster can do nothing else.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Like teleport, but this is simpler - it is just a JumpToLocation to the
    place.

    Note: Teleport can be disabled if the creature is in a "No teleport" box,
    or attempts to jump into one, or the area is a "no teleport" area.

    Could do with a door visual like BG2

    The caster is always moved. Then, each creature within 5M (nearest to futhest)
    and making sure the size is right, gets moved too at the same time. Visuals
    are applied for each one, and JumpToLocation is used.

    They must not be in combat, however.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_DIMENSION_DOOR)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    location lTarget = GetSpellTargetLocation();
    location lCaster = GetLocation(oCaster);
    int iCasterLevel = PHS_GetCasterLevel();
    object oParty;
    int iPartySize, iCnt, iTotalSizesGot;

    // 1 medium other creature per 3 caster levels
    int iTotalSizesLimit = PHS_LimitInteger(iCasterLevel/3);

    // Duration is 1 turn
    float fDuration = 6.0;

    // Declare effects
    effect eDissappear = EffectVisualEffect(PHS_VFX_IMP_DIMENSION_DOOR_DISS);
    effect eAppear = EffectVisualEffect(PHS_VFX_IMP_DIMENSION_DOOR_APPR);

    // Duration effect for stopping the caster do anything else
    effect eDur = EffectCutsceneParalyze();

    // Make sure we can teleport
    if(!PHS_CannotTeleport(oCaster, lTarget))
    {
        // Jump to the target location with visual effects
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDissappear, lCaster);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAppear, lTarget);

        // Jump
        DelayCommand(1.0, JumpToLocation(lTarget));

        // Get party members
        iCnt = 1;
        oParty = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCaster, iCnt);
        while(GetIsObjectValid(oParty) &&
              GetDistanceToObject(oParty) < 5.0 &&
              iTotalSizesGot < iTotalSizesLimit)
        {
            // - Faction equal check
            // - Make sure the creature is not doing anything
            // - Not got the dimension stopping effects
            if(GetFactionEqual(oParty) &&
               GetCurrentAction(oParty) == ACTION_INVALID &&
              !PHS_GetDimensionalAnchor(oParty))
            {
                // Check size
                iPartySize = PHS_GetSizeModifier(oParty);

                // Makes sure we can currently teleport the creature
                if(iPartySize + iTotalSizesGot < iTotalSizesLimit)
                {
                    AssignCommand(oParty, JumpToLocation(lTarget));
                    // Add amount to what we jumped with us
                    iTotalSizesGot += iPartySize;
                }
            }
            iCnt++;
            oParty = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCaster, iCnt);
        }
        // Caster cannot move for 1 turn now.
        DelayCommand(1.5, SendMessageToPC(oCaster, "You cannot perform any more actions for 1 turn due to the casting of Dimension Door"));
        DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, fDuration));
    }
}
