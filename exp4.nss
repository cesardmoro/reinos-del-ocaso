void main()
{
object oPlayer = OBJECT_SELF;
if((GetCurrentHitPoints(oPlayer) < -10) && ((GetCampaignInt("Muertes", "iXP", oPlayer) == 3 )))
{
SetCampaignInt("Muertes", "iXP", 5, oPlayer);
FloatingTextStringOnCreature("Han Pasado 6 Horas Desde Tu Muerte", oPlayer);
}}
