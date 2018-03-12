//::///////////////////////////////////////////////
//:: Spell: Teleport
//:: sp_teleport
//:://////////////////////////////////////////////
/** @file
    Teleport

    Conjuration (Teleportation)
    Level: Sor/Wiz 5, Travel 5
    Components: V
    Casting Time: 1 standard action
    Range: Personal and touch
    Target: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None
    Spell Resistance: No

    This spell instantly transports you to a designated destination, which may
    be as distant as 100 miles per caster level. Interplanar travel is not
    possible. You may also bring one additional willing Medium or smaller
    creature or its equivalent (see below) per three caster levels. A Large
    creature counts as two Medium creatures, a Huge creature counts as two Large
    creatures, and so forth. All creatures to be transported must be in contact
    with one another, and at least one of those creatures must be in contact
    with you. *

    You must have some clear idea of the location and layout of the destination.
    The clearer your mental image, the more likely the teleportation works.
    Areas of strong physical or magical energy may make teleportation more
    hazardous or even impossible. **

    To see how well the teleportation works, roll d% and consult the Teleport
    table. Refer to the following information for definitions of the terms on
    the table.

    On Target: You appear where you want to be.
    Off Target: You appear safely a random distance away from the destination
      in a random direction.
    Far Off Target: You wind up somewhere completely different.
    Mishap: You and anyone else teleporting with you have gotten “scrambled.”
      You each take 1d10 points of damage, and you reroll on the chart to see
      where you wind up. For these rerolls, roll 1d20+80. Each time “Mishap”
      comes up, the characters take more damage and must reroll.

    On Target Off Target Way Off Target Mishap
    01–90     91–94      95–98          99–100


    Notes:
     *  Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
     ** Implemented as you having to have marked the location beforehand using the "Mark Location"
        feat, found under the Teleport Options radial.


    @author Ornedan
    @date   Created 2005.11.05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "PHS_INC_SPELLS"
#include "inc_draw"
#include "SPC_inc"
#include "Muerte_inc"

void main()
{
    object oParty;
    object oCaster = OBJECT_SELF;

    if (GetArea(oCaster)==GetArea(GetWaypointByTag(WAYPOINT_FUGUE)))
        return;

    int iPartySize, iCnt, iTotalSizesGot;
    int iCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    // 1 medium other creature per 3 caster levels
    int iTotalSizesLimit = PHS_LimitInteger(8*iCasterLevel/3);
    effect eDissappear = EffectVisualEffect(PHS_VFX_IMP_DIMENSION_DOOR_DISS);
    effect eAppear = EffectVisualEffect(PHS_VFX_IMP_DIMENSION_DOOR_APPR);
    int nParty = GetSpellId();
    int bTeleportingParty;

    if(nParty == 2875)
    {
        bTeleportingParty = FALSE;
    }
    if(nParty == 2876)
    {
        bTeleportingParty = TRUE;
    }
    location lTarget = GetCampaignLocation("Teleport", "loc", oCaster);

    location lCaster = GetLocation(OBJECT_SELF);
    BeamPolygon(DURATION_TYPE_PERMANENT, VFX_BEAM_LIGHTNING, lCaster,
        bTeleportingParty ? FeetToMeters(10.0) : FeetToMeters(3.0), // Single TP: 3ft radius; Party TP: 10ft radius
        bTeleportingParty ? 15 : 10, // More nodes for the group VFX
        1.5f, "prc_invisobj", 1.0f, 0.0f, 0.0f, "z", 0.0f, 0.0f,
        -1, -1, 0.0f, 1.0f, // No secondary VFX
        2.0f // Non-zero lifetime, so the placeables eventually get removed
        );
    BeamPolygon(DURATION_TYPE_PERMANENT, VFX_BEAM_LIGHTNING, lTarget,
        bTeleportingParty ? FeetToMeters(10.0) : FeetToMeters(3.0), // Single TP: 3ft radius; Party TP: 10ft radius
        bTeleportingParty ? 15 : 10, // More nodes for the group VFX
        1.5f, "prc_invisobj", 1.0f, 0.0f, 0.0f, "z", 0.0f, 0.0f,
        -1, -1, 0.0f, 1.0f, // No secondary VFX
        2.0f // Non-zero lifetime, so the placeables eventually get removed
        );
    if(nParty == 2875)
    {

            SisPremioCombate_quitarPorcentajeXpTransitoria( OBJECT_SELF, 100 );
            DelayCommand(0.5, AssignCommand(OBJECT_SELF, ActionJumpToLocation(lTarget)));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDissappear,lCaster);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(463),OBJECT_SELF);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAppear,lTarget);

    }

    if(nParty == 2876)
    {

            SisPremioCombate_quitarPorcentajeXpTransitoria( OBJECT_SELF, 100 );
            DelayCommand(0.5, AssignCommand(OBJECT_SELF, ActionJumpToLocation(lTarget)));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eDissappear,lCaster);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(463),lCaster);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAppear,lTarget);


        iCnt = 1;
        oParty = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCaster, iCnt);
        while(GetIsObjectValid(oParty) &&
            GetDistanceToObject(oParty) < 10.0 &&
            iTotalSizesGot < iTotalSizesLimit && oParty != OBJECT_SELF)
        {
            // - Faction equal check
            // - Make sure the creature is not doing anything
            // - Not got the dimension stopping effects
            if(GetFactionEqual(oParty) &&
                GetCurrentAction(oParty) == ACTION_INVALID &&
                !PHS_GetDimensionalAnchor(oParty))
            {
                // Check size
                iPartySize = 8 + PHS_GetSizeModifier(oParty);
                if( iPartySize <= 0 )
                    iPartySize = 1;

                // Makes sure we can currently teleport the creature
                if(iPartySize + iTotalSizesGot < iTotalSizesLimit)
                {
                    // se pierde toda la experiencia acumulada
                    SisPremioCombate_quitarPorcentajeXpTransitoria( oParty, 100 );

                    AssignCommand(oParty, ClearAllActions());
                    DelayCommand(0.5, AssignCommand(oParty, ActionJumpToLocation(lTarget)));
                    // Add amount to what we jumped with us
                    iTotalSizesGot += iPartySize;
                }
            }
            iCnt += 1;
            oParty = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_FRIEND, oCaster, iCnt);
        }}

}
