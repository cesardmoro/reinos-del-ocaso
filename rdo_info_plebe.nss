//::///////////////////////////////////////////////
//:: FileName rdo_info_plebe
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 04/07/2006 03:58:19 p.m.
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Realizar las pruebas de habilidad
    if(!(AutoDC(DC_EASY, SKILL_LORE, GetPCSpeaker())))
        return FALSE;

    // Agregar la aleatoriedad
    if(Random(100) >= 50)
        return FALSE;

    return TRUE;
}
