void main()
{
    effect ePoly = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(ePoly))
    {
        if (GetEffectCreator(ePoly) == OBJECT_SELF && GetEffectType(ePoly) == EFFECT_TYPE_POLYMORPH)
            RemoveEffect(OBJECT_SELF, ePoly);
        ePoly = GetNextEffect(OBJECT_SELF);
    }
}
