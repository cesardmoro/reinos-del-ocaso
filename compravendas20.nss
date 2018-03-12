//-------------------------------//
//Autor: Marduk                  //
//Entrega 20 vendas por 40 de oro//
//Usado por conversacion "clerigo" de los NPC clerigos que estan en servicio en los templos
//-------------------------------//


void main() {
    object oPC = GetPCSpeaker();

    if (GetGold(oPC) >= 40) {
        int nIndex;
        for (nIndex = 1; nIndex <= 20; nIndex++) {
            CreateItemOnObject("vendas", oPC, 1, "vendas");
        }
        AssignCommand(oPC, TakeGoldFromCreature(40, oPC, TRUE));
    }
    else {
        SendMessageToPC(oPC, "Oro insuficiente.");
    }
}
