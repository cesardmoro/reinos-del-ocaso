#include "prc_feat_const"
#include "Mercenario_itf"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int maximoMercenarios = (GetHasFeat(FEAT_LEADERSHIP)) ? 6 : 4;
    int cantidadMercenarios = Mercenario_getCantidad( oPC ); //GetLocalInt(oPC, "cantidadMercenarios");
    if (cantidadMercenarios >= maximoMercenarios)
        return FALSE;

    return TRUE;
}
