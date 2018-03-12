#include "Mercenario_inc"

void main()
{
    object oPC = GetPCSpeaker();
    string sID = GetName(oPC); if(GetStringLength(sID) > 0) { sID = GetStringLeft(sID, 25); }
    if (GetLocalInt(OBJECT_SELF, "Accion"+sID)==1) {
        SetLocalInt(OBJECT_SELF, "merc", 1);
        SetLocalString(OBJECT_SELF, "master", GetName(oPC));
        AddHenchman(oPC, OBJECT_SELF);
        //SetLocalInt(oPC, "cantidadMercenarios", GetLocalInt(oPC, "cantidadMercenarios")+1);

        MercSpawn_onMercContracted( oPC, OBJECT_SELF );
    } else if (GetLocalInt(OBJECT_SELF, "Accion"+sID)==3) {
        //AdjustReputation(GetPCSpeaker(), OBJECT_SELF, -100);
        AssignCommand(OBJECT_SELF, ClearAllActions());
        AssignCommand(OBJECT_SELF, ActionAttack(oPC));
    }
}
