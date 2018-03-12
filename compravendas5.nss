//-------------------------------//
//Autor: Marduk
//Entrega 5 vendas por 10 de oro//
//Usado por conversacion "clerigo" de los NPC clerigos que estan en servicio en los templos
//-------------------------------//

void main() {
    object oPC = GetPCSpeaker();

    if (GetGold(oPC) >= 10) {
        int nIndex;
        for (nIndex = 1; nIndex <= 5; nIndex++) {
            CreateItemOnObject("vendas", oPC, 1, "vendas");
        }
        AssignCommand(oPC, TakeGoldFromCreature(10, oPC, TRUE));
    }
    else {
        SendMessageToPC(oPC, "Oro insuficiente.");
   }
}
