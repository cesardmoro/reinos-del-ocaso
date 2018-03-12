void main()
{
object oPC = GetExitingObject();
RemoveEffect(oPC, EffectSkillIncrease(SKILL_CRAFT_ARMOR, 100));
RemoveEffect(oPC, EffectSkillIncrease(SKILL_CRAFT_WEAPON, 100));
}
