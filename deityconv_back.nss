int StartingConditional()
{
    // Returns TRUE if were earlier deities listed.
    return GetLocalInt(OBJECT_SELF, "DeityList_Begin") > 0;
}
