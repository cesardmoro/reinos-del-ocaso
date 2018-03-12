#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "prc_spell_const"

void RemoveOldSongs(object oTarget)
{
   if (GetHasSpellEffect(SPELL_DSL_SONG_STRENGTH,oTarget)) RemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_STRENGTH);
   if (GetHasSpellEffect(SPELL_DSL_SONG_COMPULSION,oTarget)) RemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_COMPULSION);
   if (GetHasSpellEffect(SPELL_DSL_SONG_SPEED,oTarget)) RemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_SPEED);
   if (GetHasSpellEffect(SPELL_DSL_SONG_FEAR,oTarget)) RemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_FEAR);
   if (GetHasSpellEffect(SPELL_DSL_SONG_HEALING,oTarget)) RemoveEffectsFromSpell(oTarget, SPELL_DSL_SONG_HEALING);

}


void main()
{

   int iConc = GetLocalInt(GetAreaOfEffectCreator(), "SpellConc");
   if (!iConc)
   {
        RemoveOldSongs(GetAreaOfEffectCreator());
        DestroyObject(OBJECT_SELF);     
   }
 
}