int StartingConditional()
{
    if ((GetPCSpeaker()!=GetMaster()) || (GetWeather(GetArea(OBJECT_SELF))!=WEATHER_RAIN))
        return FALSE;

    return TRUE;
}
