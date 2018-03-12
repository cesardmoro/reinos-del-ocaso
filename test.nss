void main()
{
object oItem = OBJECT_SELF;
object oUser = OBJECT_SELF;
if(GetName(oItem) == "Runa sin usar")
{
SetCampaignLocation("Teleport", "loc", GetLocation(oUser), oItem);
SetName(oItem, GetName(GetArea(oUser)));
}
if(GetStringLeft(GetName(oItem), 6) == "Runa a")
{
SetCampaignLocation("Teleport", "loc", GetCampaignLocation("Teleport", "loc", oItem), oUser);
SendMessageToPC(oUser, "Runa activada");
}
}
