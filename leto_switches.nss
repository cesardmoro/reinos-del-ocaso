int GetPRCSwitch(string sSwitch);

int GetPRCSwitch(string sSwitch)
{
    return GetLocalInt(GetModule(), sSwitch);
}
