// Blood of the Warlord - On Exit

#include "nw_i0_spells"
#include "prc_spell_const"

void main()
{
    object oCreator = GetAreaOfEffectCreator(OBJECT_SELF);
    object oExit = GetExitingObject();

    if (GetHasSpellEffect(SPELL_BLOOD_OF_THE_WARLORD, oExit))
    {
        RemoveSpellEffects(SPELL_BLOOD_OF_THE_WARLORD, oCreator, oExit);
    }
}

