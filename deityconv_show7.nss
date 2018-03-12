// Returns TRUE if the seventh token has data.

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "DeityList_LastToken") >= 7;

}
