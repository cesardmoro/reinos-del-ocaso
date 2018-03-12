//::///////////////////////////////////////////////
//:: Greater Teleport spellscript
//:: sp_grtr_teleport
//:://////////////////////////////////////////////
/** @file
    Teleport, Greater

    Conjuration (Teleportation)
    Level: Sor/Wiz 7, Travel 7
    Components: V
    Casting Time: 1 standard action
    Range: Personal and touch
    Target: You and touched objects or other touched willing creatures
    Duration: Instantaneous
    Saving Throw: None and Will negates (object)
    Spell Resistance: No and Yes (object)

    This spell instantly transports you to a designated destination. You may also
    bring one additional willing Medium or smaller creature or its equivalent per
    three caster levels. A Large creature counts as two Medium creatures, a Huge
    creature counts as two Large creatures, and so forth. All creatures to be
    transported must be in contact with you. *

    Notes:
     * Implemented as within 10ft of you due to the lovely quality of NWN location tracking code.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 24.06.2005
//:://////////////////////////////////////////////

#include "spinc_teleport"

const int SPELLID_TELEPORT_SELF_ONLY = 2894;
const int SPELLID_TELEPORT_PARTY     = 2895;


void main()
{
    // Set the spell school
    SPSetSchool(SPELL_SCHOOL_CONJURATION);
    // Spellhook
    if(!X2PreSpellCastCode()) return;

    /* Main script */
    object oCaster = OBJECT_SELF;

    if (GetArea(oCaster)==GetArea(GetObjectByTag(WAYPOINT_FUGUE)))
        return;

    int nCasterLvl = PRCGetCasterLevel();
    int nSpellID   = PRCGetSpellId();

    Teleport(oCaster, nCasterLvl, nSpellID == SPELLID_TELEPORT_PARTY, TRUE, "");

    SPSetSchool();
}
