/********************************************************************

 INSPIRATIONAL BOOST
 Enchantment (Compulsion) [Mind-Affecting, Sonic]
 Level: Bard 1
 Components: V, S
 Casting Time: 1 swift action
 Range: Personal
 Target: You
 Duration: 1 round or special; see text

 You concentrate on assisting your friends as you begin the short chant and simple
 handchopping motion necessary to cast the spell. As you finish, the spell’s chant
 allows you to segue easily into bolstering your allies.

 While this spell is in effect, the morale bonus granted by your inspire courage
 bardic music increases by 1. The effect lasts until your inspire courage effect ends.
 If you don’t begin to use your inspire courage ability before the beginning of
 your next turn, the spell’s effect ends.

********************************************************************/

#include "spinc_common"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    SPSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    effect eVis = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, RoundsToSeconds(2) );

    SPSetSchool();
}
