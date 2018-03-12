void main()
{
        int nCasterLevel = GetAbilityModifier(ABILITY_WISDOM)<1 ? 1 : GetAbilityModifier(ABILITY_WISDOM);


        effect eAC = EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS);
        eAC = EffectLinkEffects(eAC, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        eAC = EffectLinkEffects(eAC,EffectSavingThrowIncrease(SAVING_THROW_ALL,4));
        eAC = EffectLinkEffects(eAC,EffectSpellResistanceIncrease(25));

	effect eVFX = EffectVisualEffect(VFX_IMP_AC_BONUS);

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eAC), OBJECT_SELF, RoundsToSeconds(nCasterLevel));
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);

}
