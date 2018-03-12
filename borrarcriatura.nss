void main()
{
    if(GetIsInCombat(OBJECT_SELF) == FALSE)
    {
    if(GetLocalInt(OBJECT_SELF, "daxp") == 1)
    {
    SetIsDestroyable(TRUE,FALSE,FALSE);
    //ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF);
    DestroyObject(OBJECT_SELF, 0.0);
    }
    }
}
