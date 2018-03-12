#include "Mercenario_inc"

void main()
{
    object oPC = GetPCSpeaker();
    AddHenchman(oPC, OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "merc", 1);
    //SetLocalInt(oPC, "cantidadMercenarios", GetLocalInt(oPC, "cantidadMercenarios")+1);
    MercSpawn_onMercContracted( oPC, OBJECT_SELF );
}
