void main()
{
    //fake it
    switch(GetLocalInt(OBJECT_SELF, "FeatToUse"))
    {
        case FEAT_ANIMAL_COMPANION:
            DecrementRemainingFeatUses(OBJECT_SELF, FEAT_ANIMAL_COMPANION);
            SummonAnimalCompanion();
            break;
        case FEAT_SUMMON_FAMILIAR:
            DecrementRemainingFeatUses(OBJECT_SELF, FEAT_SUMMON_FAMILIAR);
            SummonFamiliar();
            break;
    }
}
