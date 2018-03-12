// Returns TRUE if the sixth token has data.

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "DeityList_LastToken") >= 6;

}
