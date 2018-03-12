void main()
{
int nDam = GetLocalInt(OBJECT_SELF, "damage");
effect eDam = SupernaturalEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, nDam));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, OBJECT_SELF);
}
