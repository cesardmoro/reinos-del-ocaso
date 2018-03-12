int StartingConditional() {
    return
        GetLocalString(OBJECT_SELF, "master") == GetName(GetPCSpeaker())
        && GetMaster(OBJECT_SELF) == OBJECT_INVALID
    ;
}
