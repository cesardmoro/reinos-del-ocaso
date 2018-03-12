int StartingConditional()
{
    // Returns TRUE if there are more deities to list.
    return GetLocalInt(OBJECT_SELF, "DeityList_Begin") +
           GetLocalInt(OBJECT_SELF, "DeityList_LastToken")
           < GetLocalInt(OBJECT_SELF, "DeityList_Count");
}
