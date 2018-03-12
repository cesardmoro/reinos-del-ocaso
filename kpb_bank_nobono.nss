int StartingConditional()
{
    if (GetIsPC(GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
