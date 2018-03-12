int StartingConditional()
{
    effect ePoly = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(ePoly))
    {
        if (GetEffectCreator(ePoly) == OBJECT_SELF && GetEffectType(ePoly) == EFFECT_TYPE_POLYMORPH)
            return TRUE;
        ePoly = GetNextEffect(OBJECT_SELF);
    }
    return FALSE;
}
