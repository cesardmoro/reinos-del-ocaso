#include "prc_inc_domain"

void main()
{
    // Used by the uses per day check code for bonus domains
    if (!DecrementDomainUses(DOMAIN_SUN, OBJECT_SELF)) return;
    ActionDoCommand(SetLocalInt(OBJECT_SELF, "UsingSunDomain", TRUE));
    ActionCastSpell(SPELLABILITY_TURN_UNDEAD);
    ActionDoCommand(DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD));
    ActionDoCommand(DeleteLocalInt(OBJECT_SELF, "UsingSunDomain"));
}