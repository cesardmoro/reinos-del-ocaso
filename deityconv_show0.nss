int StartingConditional()
{
    // Returns true if there are no deities to list.
    return GetLocalInt(OBJECT_SELF, "DeityList_Count") == 0;
}
