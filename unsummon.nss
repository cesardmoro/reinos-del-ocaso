void main()
{
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oSummon));
    DestroyObject(oSummon);
}
