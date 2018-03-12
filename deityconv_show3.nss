// Returns TRUE if the third token has data.

int StartingConditional()
{
    return GetLocalInt(OBJECT_SELF, "DeityList_LastToken") >= 3;

}
