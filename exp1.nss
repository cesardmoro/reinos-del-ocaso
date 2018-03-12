void main()
{
object oPlayer = OBJECT_SELF;
if((GetCurrentHitPoints(oPlayer) < -10) && ((GetCampaignInt("Muertes", "iXP", oPlayer) == 0 )))
{
SetCampaignInt("Muertes", "iXP", 1, oPlayer);
FloatingTextStringOnCreature("Han Pasado 3 Horas Desde Tu Muerte", oPlayer);
}}
