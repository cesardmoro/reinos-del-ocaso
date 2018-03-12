#include "zep_inc_craft"

void main()
{
object oPC = GetPCSpeaker();
DelayCommand(2.0, ZEP_StopCraft(oPC, FALSE));
}
