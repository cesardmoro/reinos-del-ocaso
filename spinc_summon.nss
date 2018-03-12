
void sp_summon(string creature, int impactVfx)
{
	SPSetSchool(SPELL_SCHOOL_CONJURATION);

	// Check to see if the spell hook cancels the spell.
	if (!X2PreSpellCastCode()) return;

	// Get the duration, base of 24 hours, modified by metamagic	
	float fDuration = SPGetMetaMagicDuration(HoursToSeconds(24));
    
    // Apply impact VFX and summon effects.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(impactVfx), 
		GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(creature), 
		GetSpellTargetLocation(), fDuration);
	
	SPSetSchool();
}
