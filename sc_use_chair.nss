/// Usar silla ///
void main()
{
    object oChair = OBJECT_SELF;
    if (!GetIsObjectValid(GetSittingCreature(OBJECT_SELF))) {
        AssignCommand(GetLastUsedBy(), ActionSit(oChair));
    }
}
