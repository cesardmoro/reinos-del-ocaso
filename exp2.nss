void main()
{
object oPlayer = OBJECT_SELF;
if((GetCurrentHitPoints(oPlayer) < -10) && ((GetCampaignInt("Muertes", "iXP", oPlayer) == 1 )))
{
SetCampaignInt("Muertes", "iXP", 3, oPlayer);
FloatingTextStringOnCreature("Han Pasado 4 Horas Desde Tu Muerte", oPlayer);
}}
