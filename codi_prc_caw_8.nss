int StartingConditional()
{
    int iReturn = GetLocalInt(GetPCSpeaker(),"CODI_HAS_ALTAR");
    return !iReturn;
}

