/*:://////////////////////////////////////////////
//:: Spell Name Antilife Shell
//:: Spell FileName PHS_S_AntilifeS
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    3.2M.- Radius, 10 min/level. Sepll resistance: Yes.

    Hedges out living creatures:
    - The effect hedges out animals, aberrations, dragons, fey, giants, humanoids,
    magical beasts, monstrous humanoids, oozes, plants, and vermin, but not
    constructs, elementals, outsiders, or undead.
    - Any creature already inside the Antilife Shell when cast can remain there.
    This spell may be used only defensively, not aggressively. If anything enters
    while moving, it breaks the spell.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    It is a mobile barrier, with a special AOE.

    Basically, if the caster is doing an ACTION_TYPE_MOVE_TO_POINT and someone
    activates the OnEnter script, that creature makes the barrier collapse.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_ANTILIFE_SHELL)) return;

    // Declare major variables
    object oTarget = OBJECT_SELF;// Should be OBJECT_SELF.
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PHS_GetCasterLevel();
    int nMetaMagic = GetMetaMagicFeat();

    // Duration in 10 turns/level
    float fDuration = PHS_GetDuration(PHS_TURNS, nCasterLevel * 10, nMetaMagic);

    // Declare effects - only an enter script.
    // - Use scripts defined in the 2da.
    effect eMob = EffectAreaOfEffect(PHS_AOE_MOB_ANITLIFE_SHELL/*, "PHS_S_ANTILIFESA", "****", "****"*/);

    // Remove previous effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_ANTILIFE_SHELL, oTarget);

    // Set local integer so that the first ones will not be affected, which
    // is removed after 1.0 seconds.
    SetLocalInt(oTarget, PHS_MOVING_BARRIER_START, TRUE);
    DelayCommand(1.0, DeleteLocalInt(oTarget, PHS_MOVING_BARRIER_START));

    // Apply effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMob, oTarget, fDuration);
}
