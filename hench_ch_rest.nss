//:://////////////////////////////////////////////////
//:: X0_CH_HEN_REST
/*
  OnRest event handler for henchmen/associates.
 */
//:://////////////////////////////////////////////////
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 01/06/2003
//:://////////////////////////////////////////////////
#include "cu_spells"

void CheckRest2(int nOldTime)
{
    int nLevel = GetHitDice(OBJECT_SELF);
    int nRestTime = StringToInt(CU_Get2DAString("restduration", "DURATION", nLevel)) / 1000;
    int nTime = GetTimeSecond() + 60 * (GetTimeMinute() + 60 * (GetTimeHour() + 24 * GetCalendarDay()));
    int nDif = nTime - nOldTime;
    if (nDif > (nRestTime - 3))
    {
        CU_RestoreSpells();
    }
}

void CheckRest()
{
    int nTime = GetTimeSecond() + 60 * (GetTimeMinute() + 60 * (GetTimeHour() + 24 * GetCalendarDay()));
    if (GetIsResting())
    {
        ActionDoCommand(CheckRest2(nTime));
    }
}

void main()
{
    if (GetLocalInt(OBJECT_SELF, "UseSpellBook"))
        DelayCommand(1.0, CheckRest());
}
