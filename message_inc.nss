//////////////
// 09/04/07 Script By Dragoncin
//
// Utilidades para enviar mensajes a PJs
//////////////////////

void SendMessageToPCAndBoot( object oPC, string mensaje );
void SendMessageToPCAndBoot( object oPC, string mensaje )
{
    SendMessageToPC(oPC, mensaje);
    SendMessageToPC(oPC, "Desconectando en 5...");
    DelayCommand(1.0, SendMessageToPC(oPC, "4..."));
    DelayCommand(2.0, SendMessageToPC(oPC, "3..."));
    DelayCommand(3.0, SendMessageToPC(oPC, "2..."));
    DelayCommand(4.0, SendMessageToPC(oPC, "1..."));
    DelayCommand(5.0, BootPC(oPC));
}
