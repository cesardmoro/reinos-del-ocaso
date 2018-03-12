/**
 * Thrall of Orcus: Create Major Undead
 * 2004/07/12
 * Stratovarius
 */

void main()
{
    string sSummon = "prc_to_mummy";
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

   effect eSum = EffectSummonCreature(sSummon, VFX_NONE);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
   ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSum, GetSpellTargetLocation());
}