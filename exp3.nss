void main()
{
object oPlayer = OBJECT_SELF;
if((GetCurrentHitPoints(oPlayer) < -10) && ((GetCampaignInt("Muertes", "iXP", oPlayer) == 2 )))
{
SetCampaignInt("Muertes", "iXP", 4, oPlayer);
FloatingTextStringOnCreature("Han Pasado 5 Horas Desde Tu Muerte", oPlayer);
}}
