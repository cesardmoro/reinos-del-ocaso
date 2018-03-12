struct ChatMessage
{
    object speaker;
    int volume;
    string content;
};

// Repite un mensaje flotante numeroDeRepeticiones veces cada fDelay tiempo
void mensajeFlotanteReiterativo( object oPC, string mensaje, int numeroRepeticiones = 5, float fDelay = 5.0 );
void mensajeFlotanteReiterativo( object oPC, string mensaje, int numeroRepeticiones = 5, float fDelay = 5.0 )
{
    int contadorMensajeRetrasado = GetLocalInt(oPC, "contadorMensajeRetrasado");
    if (GetIsObjectValid(oPC) && contadorMensajeRetrasado < numeroRepeticiones)
    {
        FloatingTextStringOnCreature( mensaje, oPC, FALSE);
        SetLocalInt(oPC, "contadorMensajeRetrasado", contadorMensajeRetrasado+1);
        DelayCommand(fDelay, mensajeFlotanteReiterativo(oPC, mensaje, numeroRepeticiones, fDelay));
    }
}
