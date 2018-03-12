// Returns TRUE if the fourth token has data.

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "DeityList_LastToken") >= 4;

}
