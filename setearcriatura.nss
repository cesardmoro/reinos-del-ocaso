void main()
{
object oPC = GetLastSpeaker();
SetCampaignInt("summons", IntToString(GetLocalInt(oPC, "conjuro")), GetLocalInt(oPC, "numero"), oPC);
SetCampaignInt("summons2", IntToString(GetLocalInt(oPC, "conjuro")), GetLocalInt(oPC, "cantidad"), oPC);
}
