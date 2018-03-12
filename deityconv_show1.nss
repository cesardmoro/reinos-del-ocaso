// Returns TRUE if the first token has data.

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "DeityList_LastToken") >= 1;

}
