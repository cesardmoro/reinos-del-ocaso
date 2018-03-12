#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;

    SetLocalInt(oPC, "Heal_Kicker3", TRUE);

    if (GetLocalInt(oPC, "Heal_Kicker1"))  SetLocalInt(oPC, "Heal_Kicker1", FALSE);
    if (GetLocalInt(oPC, "Heal_Kicker2"))  SetLocalInt(oPC, "Heal_Kicker2", FALSE);
    
    FloatingTextStringOnCreature("You have turned on kicker 3", oPC, FALSE);
    IncrementRemainingFeatUses(oPC, FEAT_HEALING_KICKER_3);
}