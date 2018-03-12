#include "Mercenario_inc"

void main()
{
    object oPC = GetPCSpeaker();
    TakeGoldFromCreature(GetLocalInt(OBJECT_SELF, "Precio"), GetPCSpeaker(), TRUE);
    AddHenchman(GetPCSpeaker(), OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "vsDC", 10);
    SetLocalInt(OBJECT_SELF, "merc", 1);
    SetLocalString(OBJECT_SELF, "master", GetName(oPC));
    //SetLocalInt(oPC, "cantidadMercenarios", GetLocalInt(oPC, "cantidadMercenarios")+1);

    MercSpawn_onMercContracted( oPC, OBJECT_SELF );
}
