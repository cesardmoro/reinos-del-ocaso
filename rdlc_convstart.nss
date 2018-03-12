int StartingConditional()
{
    object oPC = GetPCSpeaker();
    SetCustomToken(4201, GetLocalString(oPC, "rdlc_token"));
    DeleteLocalString(oPC, "rdlc_token");

    return TRUE;
}
