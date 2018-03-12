int StartingConditional()
{
    if (GetPCSpeaker()!=GetMaster())
        return FALSE;

    return TRUE;
}
