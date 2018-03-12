void main()
{
//SetIsDestroyable(FALSE, TRUE, TRUE);
ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), OBJECT_SELF);
DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF));

DestroyObject(OBJECT_SELF, 1.0);

}
