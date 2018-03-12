#include "prc_feat_const"
#include "Mercenario_itf"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    int maximoMercenarios = (GetHasFeat(FEAT_LEADERSHIP)) ? 6 : 4;
    int cantidadMercenarios = Mercenario_getCantidad( oPC ); //GetLocalInt(oPC, "cantidadMercenarios");
    if (cantidadMercenarios >= maximoMercenarios)
        return FALSE;

    return
        GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0
        && GetLevelByClass(CLASS_TYPE_CLERIC, OBJECT_SELF) > 0
        && GetDeity(oPC)==GetDeity(OBJECT_SELF)
    ;
}
