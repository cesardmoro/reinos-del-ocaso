#include "prc_alterations"

void main()
{
    SetLocalInt(OBJECT_SELF, "UsingZoneOfAnimation", TRUE);
    ActionCastSpell(SPELLABILITY_TURN_UNDEAD);
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
    DelayCommand(3.0, DeleteLocalInt(OBJECT_SELF, "UsingZoneOfAnimation"));
}