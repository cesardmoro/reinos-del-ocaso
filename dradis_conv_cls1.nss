const int CLASS_POSITION = 1;

int StartingConditional()
{
    int clase = GetClassByPosition(CLASS_POSITION, GetPCSpeaker());
    return (clase == CLASS_TYPE_SORCERER || clase == CLASS_TYPE_BARD);
}
